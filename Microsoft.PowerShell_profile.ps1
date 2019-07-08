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

function Reset-Path {
    $env:PATH = $ORIGINAL_PATH
}

# Update path
# Slow. Takes ~150ms.
# I could try to do all of this in one go by making Add-Path take a list.
# Add dumpbin.exe and friends to powershell path.
Add-Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Tools\MSVC\14.11.25503\bin\Hostx64\x64'
# Add devenv.exe etc.
Add-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7"
# Add gvim to path
Add-Path "C:\Program Files (x86)\Vim\vim80"
# Scripts
Add-Path "$home\scripts"
# WinDbg and WinDbgX
Add-Path "C:\Debuggers"
Add-Path "C:\Users\iakronqu\AppData\Local\dbg\UI"
# devenv
Add-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE"
# Git unix tools like less.
Add-Path 'C:\Program Files\Git\usr\bin'
Add-Path 'C:\Program Files\Git\bin'


# Aliases
function ll { ls $args }
function l { ls $args }

function hex { echo ('0x{0:x}' -f $args[0]) }

function Show-ErrorCode {
    if (!$?) {
        if ($LASTEXITCODE) {
            Write-Host -ForegroundColor Red -NoNewline ("{0:x} " -f $LASTEXITCODE)
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
            $_=$(Get-Content $sdxroot\.git\HEAD) -match 'refs/heads.*/(.*)$'
                if ($matches[1]) {
                    Write-Host -ForegroundColor DarkGreen -NoNewline "$($matches[1]) "
                } else {
                    Write-Host -ForegroundColor DarkGreen -NoNewline "$($matches[0]) "
                }
        }
        catch {
            Write-Host -ForegroundColor DarkGreen -NoNewline "Detatched HEAD? "
        }
        return "$(Get-Location)>"
    }
} else {
    function asan() {
        pushd C:\Users\iakronqu\source\asan\asan-utc\
    }
    function llvm() {
        pushd C:\Users\iakronqu\source\llvm\
    }

    # Updating the prompt is slow, ~150ms.
    # Change prompt to include the last exit code
    function prompt {
        Show-ErrorCode
        return "$(Get-Location)>"
    }
}

$msvc='~/source/msvc'
function msvc { pushd $msvc }

# Open the file(s) in a new tab in the existing gvim instance.
function v {
    # Special case -t 'open tag' because vim command parsing is weird.
    if ($args[0] -Eq '-t') {
        $tag = $args[1]

        gvim --remote-send ":execute('tab tag $tag')<CR>"
    } else {
        gvim -p --remote-tab-silent $args
    }
}

# Open each file under source control which has been modified in a new tab in gvim.
function vg {
    # Take the output of git status -s, match anything which has been modified, and for each match,
    # convert it to a string, and remove the match marker from the front.
    # Then feed all that to gvim as a series of command line arguments
    gvim -p $(git status -s | Select-String " M " | ForEach-Object { $_.ToString().trim(" M ") })
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
    #if ("$PWD".startswith($sdxroot, "CurrentCultureIgnoreCase")) {
    #    Write-Host -ForegroundColor Red -NoNewline "Don't search the GVFS repo!"
    #    return
    #}
    Get-ChildItem $file -recurse -filter $regex -file | foreach-object { $_.fullname.tostring() }
}

function pydoc () {
    python -m pydoc $args
}

function title () {
    $host.ui.RawUI.WindowTitle = "$args"
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

# Changing the PSReadline options takes ~250ms, very slow.
Set-PSReadlineOption -Colors @{
    "Operator" = [ConsoleColor]::Yellow
    "Parameter" = [ConsoleColor]::Yellow
}

# Does not work well with ctrl-r
#Set-PSReadlineOption -EditMode vi
#Set-PSReadlineOption -HistorySearchCursorMovesToEnd False

$ORIGINAL_PATH = $env:PATH
