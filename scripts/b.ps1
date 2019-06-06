Param(
    [parameter(Mandatory=$true,
               HelpMessage="Build one of the following targets: w32 (Win32k), hv (Hyper-V), mk (minkernel), edge.")]
    [ValidateSet('w32', 'hv', 'mk', 'edge')]
    [String]
    $Target,

    [Switch]
    [alias("c")]
    $Clean,

    [Switch]
    [alias("w")]
    $Wide,

    [Switch]
    [alias("t")]
    $Tests,

    [Switch]
    [alias("d")]
    $DeployOnly
)

# To add a new target, create a function called the new target name, and add
# that name to the ValidateSet for the first parameter.

function Log($msg) {
    Write-Host $msg -Foregroundcolor Yellow
}

function Err($msg) {
    Write-Host $msg -Foregroundcolor Red
}

if (-Not (Get-ChildItem env:SDXROOT -ErrorAction SilentlyContinue)) {
    Err "This command must be run from a razzle shell!"
    exit -1
}

# Look up some environment variables.
$sdxroot = (Get-ChildItem Env:SDXROOT).Value
$arch = (Get-ChildItem Env:_BuildArch).Value
$checkedness = (Get-ChildItem Env:build.type).Value
$flavor = "$arch$checkedness"
$username = (Get-ChildItem Env:USERNAME).Value
$dest = 'c:\vmshare\' #'


if ($Clean) {
    Log 'Clean build'
    $buildcmd ="build -cZh /nosqm"
} else {
    $buildcmd ="build -h /nosqm"
}

if (-Not $Tests) {
    Log 'No tests'
    $buildcmd +=' /skiptestcode /DirInclude:!test '
}

if ($Wide) {
    Log 'Wide build'
    $width = 'wide'
} else {
    Log 'Narrow build'
    $width = 'narrow'
}


function BuildDir($dirname) {
    if (!$DeployOnly) {
        Log "Building $dirname"
        pushd $dirname
        invoke-expression $buildcmd
        popd
    }
}


function Sign($outs, $dest, $flag) {
    pushd $sdxroot\..\bin\$flavor
    Log "Signing $outs"
    Log "Going to deploy to $dest"

    ForEach ($out in $outs) {
        if (!(Test-Path $outs)) {
            Err "The output file $out doesn't exist"
            continue
        }
        if ($flag) {
            ntsign $flag $out
        } else {
            ntsign $out
        }
        cp $out $dest
    }

    popd
}

function BuildDirs($widedirlist, $narrowdirlist) {
    if ($width -Eq 'wide') {
        ForEach ($dir in $widedirlist) {
            BuildDir $dir
        }
    }

    ForEach ($dir in $narrowdirlist) {
        BuildDir $dir
    }
}

function w32() {
    $wide = "$sdxroot\onecoreuap\windows\published",
            "$sdxroot\onecore\windows\published",
            "$sdxroot\windows\published",
            "$sdxroot\onecore\windows\core\manifests",
            "$sdxroot\onecoreuap\windows\core\manifests",
            "$sdxroot\windows\core\manifests",
            "$sdxroot\onecore\base\wil",
            "$sdxroot\onecoreuap\windows\core\cslpk",
            "$sdxroot\onecoreuap\windows\core\dwmk",
            "$sdxroot\onecoreuap\windows\core\dcompk",
            "$sdxroot\onecoreuap\windows\core\w32inc",
            "$sdxroot\onecoreuap\windows\core\w32inst",
            "$sdxroot\onecoreuap\windows\core\inputmanager",
            "$sdxroot\onecoreuap\windows\core\shaping",
            "$sdxroot\windows\core\rtl",
            "$sdxroot\windows\core\dwmk",
            "$sdxroot\windows\core\cslpk"

    $narrow = "$sdxroot\onecoreuap\windows\core\ntuser",
              "$sdxroot\onecoreuap\windows\core\ntgdi",
              "$sdxroot\windows\core\ntgdi",
              "$sdxroot\windows\core\ntuser",
              "$sdxroot\onecoreuap\windows\core\kmodeconv\win32kbase",
              "$sdxroot\windows\Core\kmodeconv\win32kfull"

    $outputs = 'win32kbase.sys', 'win32kfull.sys'

    BuildDirs $wide $narrow
    Sign $outputs $dest\w32
}

function edge() {
    $narrow = "$sdxroot\shellcommon\Composable\Components\TabBar",
              "$sdxroot\shellcommon\inetcore"

    # Empty list
    $wide = @()

    BuildDirs $wide $narrow
}

function hv() {
    $wide = "$sdxroot\onecore\merged\sdk",
            "$sdxroot\minkernel\ntos\inc",
            "$sdxroot\minkernel\hals\inc",
            "$sdxroot\minkernel\hals\lib",
            "$sdxroot\minkernel\published\base",
            "$sdxroot\onecore\hv"

    $narrow = "$sdxroot\onecore\hv\hvx"

    BuildDirs $wide $narrow

    Sign "hvix64.exe" $dest\hv
}

function mk() {
    $wide = "$sdxroot\minkernel"

    $narrow = "$sdxroot\minkernel\ntdll",
              "$sdxroot\minkernel\kernelbase",
              "$sdxroot\minkernel\ntos"

    if ($arch == 'x86') {
        $outputs = "kernelbase.dll", "ntkrnlmp.exe"
    } elseif ($arch == 'amd64') {
        $outputs = "kernelbase.dll", "ntkrpamp.exe"
    } else {
        Err "bad arch $arch for target $target"
        exit -1
    }

    Sign $outputs C:\vmshare\ntos

    $outputs2 = ntdll.dll
    Sign $outputs2 $dest\ntos /h:Page
}



invoke-expression $target

Send-MailMessage -To "$username <$username@microsoft.com>" -From "Razzle <$username@microsoft.com>" -Subject "Razzle build completed $target $flavor $sdxroot $args" -SmtpServer  "smtphost.redmond.corp.microsoft.com"
