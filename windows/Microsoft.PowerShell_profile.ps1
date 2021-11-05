# Notes:
#
# $MYOBJ | Get-Member shows all properties and methods.
#
# In closures, $_ captures the arguments.
# In functions, $args holds the arguments.
#
# Environment variables can be read with Get-ChildItem env:MYVAR
#
# $? holds boolean last exit code for powershell stuff.
# $LATEXITCODE is for traditional cmd.exe programs.
#
# Get-Content cats a file.
#
# To run something which is in a string, use Invoke-Expression
#
# Check if smb is alive on port 445:
# test-NetConnection $YOURHOST -Port 445
#
# Better than ping because ping is unreliable
#
# Get-Clipboard
# Set-Clipboard
# Set-Clipboard -path ntdll.dll # Slurp ntdll file to paste into vm etc.

# Check perf with:
#$sw = [system.diagnostics.stopwatch]::startNew()

function Add-Path-Prefix {
    $paths = $env:PATH -split ';'
    $item = $args[0].TrimEnd('\') #'
    if ($paths -notcontains $item) {
        $env:PATH = $item + ';' + $env:PATH
    }
}

function Add-Path {
    $paths = $env:PATH -split ';'
    $item = $args[0].TrimEnd('\') #'
    if ($paths -notcontains $item) {
        $env:PATH += ';' + $item
    }
}

# Slow and doesn't work if $in==$out
function Convert-UTF8 ($in, $out) {
    #if (!$out) {
    #    $out = $in
    #}
    cat $in | set-content -Encoding UTF8 $out
}

function Reset-Path {
    $env:PATH = $ORIGINAL_PATH
}

# Update path
# Slow. Takes ~150ms.
# I could try to do all of this in one go by making Add-Path take a list.
# Add dumpbin.exe and friends to powershell path.
Add-Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.16.27023\bin\Hostx64\x64'
# Add devenv.exe etc.
Add-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7"
# Add gvim to path
#Add-Path "C:\Program Files (x86)\Vim\vim80"
# Scripts
#Add-Path "$home\scripts"
# WinDbg and WinDbgX
#Add-Path "C:\Debuggers"
#Add-Path "$home\AppData\Local\dbg\UI"
# devenv
Add-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE"
# Git unix tools like less.
#Add-Path 'C:\Program Files\Git\usr\bin'
#Add-Path 'C:\Program Files\Git\bin'
# Sysinternals
#Add-Path-Prefix "$home\SysinternalsSuite"


# Aliases
function ll { ls $args }
function l { ls $args }

function hex { echo ('0x{0:x}' -f $args[0]) }

function title () {
    $host.ui.RawUI.WindowTitle = "$args"
}

function Show-ErrorCode {
    if (!$?) {
        if ($LASTEXITCODE) {
            Write-Host -ForegroundColor Red -NoNewline ("0x{0:x} " -f $LASTEXITCODE)
        } else {
            Write-Host -ForegroundColor Red -NoNewline "$? "
        }
    }
}

# Only set razzle aliases if we're in a razzle prompt.
if (Get-ChildItem env:SDXROOT -ErrorAction SilentlyContinue) {
    $sdxroot = (Get-ChildItem Env:SDXROOT).Value
    $arch = (Get-ChildItem Env:_BuildArch).Value
    $checkedness = (Get-ChildItem Env:build.type).Value
    $flavor = "$arch$checkedness"
    function root { pushd $sdxroot }
    function src { pushd $sdxroot }
    function ntdll { pushd $sdxroot\minkernel\ntdll }
    function rtl { pushd $sdxroot\minkernel\ntos\rtl }
    function ntos { pushd $sdxroot\minkernel\ntos }
    function ntgdi { pushd $sdxroot\windows\Core\ntgdi }
    function ntusr { pushd $sdxroot\windows\Core\ntuser }
    function bin { pushd $sdxroot\..\bin\$flavor }
    function core { pushd $sdxroot\onecoreuap\windows\core }
    function w32kbase { pushd $sdxroot\onecoreuap\windows\core\kmodeconv\win32kbase }
    function w32inst { pushd $sdxroot\onecoreuap\windows\core\w32inst }
    function w32k { pushd $sdxroot\windows\Core\kmode }
    function w32kfull { pushd $sdxroot\windows\Core\kmodeconv\win32kfull }
    function ntos { pushd $sdxroot\minkernel\ntos }

    function bcz { build /c /Z $args }
    function bcp { build /c /P $args }
    # Quick build.
    function qbcz { build -cZh /skiptestcode /DirInclude:!test /nosqm $args }
    function qbuild { build -h /skiptestcode /DirInclude:!test /nosqm $args }

    # Updating the prompt is slow, ~150ms.
    # Change prompt to include the last exit code and the last part of the git branch in this enlistment
    function prompt {
        try {
            Show-ErrorCode
            $_dead=$(Get-Content $sdxroot\.git\HEAD) -match 'refs/heads.*/(.*)$'
            if ($matches[1]) {
                $ref=$matches[1]
            } else {
                $ref=$matches[0]
            }
            $end = (($ref.Length, 32) | Measure-Object -min).minimum
            $path = $ref.SubString(0, $end)
            if ($end -lt $ref.Length) {
                $path = $path + '…'
            }
            Write-Host -ForegroundColor DarkGreen -NoNewline "$($path) "
        }
        catch {
            Write-Host -ForegroundColor DarkGreen -NoNewline "Detached HEAD? "
        }
        return "$(Get-Location)>"
    }
    title "Razzle $sdxroot"
    # Multi-threaded compilation. Isn't this the default?
    Set-Item Env:BUILD_CL_MP 1
} else {
    #function asan() {
    #    pushd C:\Users\iakronqu\source\asan\asan-utc\
    #}
    #function llvm() {
    #    pushd C:\Users\iakronqu\source\llvm\
    #}

    # Updating the prompt is slow, ~150ms.
    # Change prompt to include the last exit code
    function prompt {
        Show-ErrorCode
        return "$(Get-Location)>"
    }
}

#$msvc='C:\Users\iakronqu\source\msvc'
#$utc="$msvc\src\vctools\Compiler\Utc"
#function msvc { pushd $msvc }

# Open the file(s) in a new tab in the existing gvim instance.
function v {
    #$sw = [system.diagnostics.stopwatch]::startNew()
    #echo $sw.Elapsed
    if ($args.length -Eq 0) {
        #echo $sw.Elapsed
        gvim
        #echo $sw.Elapsed
    } elseif ($args[0] -Eq '-t') {
        #echo $sw.Elapsed
        # Special case -t 'open tag' because vim command parsing is weird.
        $tag = $args[1]

        gvim --remote-send ":execute('tab tag $tag')<CR>"
        #echo $sw.Elapsed
    } else {

        #echo $sw.Elapsed
        # FIXME Loop through and expand args, and open each individually?
        gvim --remote-tab-silent $args
        #echo $sw.Elapsed
        # Apparently -p doesn't work?
        # For each argument
        #$args | ForEach-Object {
        #    # For each expanded item in the argument
        #    Get-ChildItem $_ | ForEach-Object {
        #        gvim --remote-tab-silent $_
        #    }
        #}
    }
}

## Open each file under source control which has been modified in a new tab in gvim.
function vg {
    # Take the output of git status -s, match anything which has been modified, and for each match,
    # convert it to a string, and remove the match marker from the front.
    # Then feed all that to gvim as a series of command line arguments
    gvim --remote-tab-silent  $(git status -s | Select-String " M " | ForEach-Object { $_.ToString().trim(" M ") })
}

# Git Aliases
function gs { git status $args }
function gd { git diff $args }
function gdn { git diff --name-only $args }

# Already used by "Get-Location" alias.
#function gl { git log }
function ga { git add $args }
function gau { git add -u $args }
function gap { git add -p $args }
function gco { git checkout $args }
function gcp { git checkout -p $args }

function grind($regex, $file) {
    if ("$PWD".startswith('d:\os\src', "CurrentCultureIgnoreCase")) {
        Write-Host -ForegroundColor Red -NoNewline "Don't search the GVFS repo!"
        return
    }
    #Get-ChildItem $file -recurse -filter $regex -file | foreach-object { $_.fullname.tostring() }
    #Get-ChildItem $file -recurse -file | foreach-object { $_.fullname.tostring() } | grep $regex
    &'c:\program files\git\usr\bin\find.exe' $file |grep -i $regex
}

function refact($search, $replace, $files) {
    if (!$dir) {
        $dir = '.'
    }
    ls $files | ForEach-Object {
        $bkp=$_.FullName + '.bkp'
        cp $_.FullName $bkp
        (Get-Content -Path $_.FullName) -replace $search, $replace | Set-Content $_.FullName
    }
}

function py2 () {
    c:\python27\python.exe $args
}

function pydoc () {
    python -m pydoc $args
}

# Thanks Nate.
function hist { Get-Content (Get-PSReadlineOption).HistorySavePath }

# Super slow I'm sure, but does the job.
function hitail() {
    $file = $args[0]
    $text = $args[1]

    Get-Content $file -Wait | ForEach {
        $color = "White"
        if ($_.Contains($text)) {
            $color = "Yellow"
        }
        Write-Host -ForegroundColor $color $_
    }
}

# https://stackoverflow.com/questions/42535773/setting-variables-for-batch-files-in-powershell
# Invokes a Cmd.exe shell script and updates the environment.
function Invoke-CmdScript {
  param(
    [String] $scriptName
  )
  $cmdLine = """$scriptName"" $args & set"
  & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
    Select-String '^([^=]*)=(.*)$' | ForEach-Object {
      $varName = $_.Matches[0].Groups[1].Value
      $varValue = $_.Matches[0].Groups[2].Value
      Set-Item Env:$varName $varValue
    }
}

# Debug msarmsim
#function armdbg() {
#    C:\Debuggers\wow64\windbg.exe -noredirect -kx 'exdi:CLSID={BF2163B8-97D0-4E71-B328-EBA8C1A99C04},Kd=Ioctl,DataBreaks=Exdi'
#}

# Changing the PSReadline options takes ~250ms, very slow.
Set-PSReadlineOption -Colors @{
    "Operator" = [ConsoleColor]::Yellow
    "Parameter" = [ConsoleColor]::Yellow
}

# Bash style line editing
# ctl+e goes to end of line
# ctl+a goes to beginning
# alt+f goes forward one word
# alt+b goes backward
#Set-PSReadLineOption -EditMode Emacs
# This is buggy and breaks autocomplete.

# Does not work well with ctrl-r
#Set-PSReadlineOption -EditMode vi
#Set-PSReadlineOption -HistorySearchCursorMovesToEnd False
#
## Not sure about these next two, but I'd like something better than ctrl+leftarrow.
Set-PSReadlineKeyHandler -Key ctrl+b -Function BackwardWord
Set-PSReadlineKeyHandler -Key ctrl+q -Function BackwardWord

# Not sure about this one, vim uses 'w', which is a good pneumonic, but this is different.
Set-PSReadlineKeyHandler -Key ctrl+w -Function NextWord
# Unapologetically bash like.
Set-PSReadlineKeyHandler -Key ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+u -Function DeleteLineToFirstChar
# A nice alternative to bash & powershell style autocomplete to explore
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Python scripts are executables.
$env:PATHEXT += ";.py"

$ORIGINAL_PATH = $env:PATH
