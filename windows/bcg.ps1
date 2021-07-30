Param(
    [parameter(Mandatory=$true,
               HelpMessage="Build a target")]
    [ValidateSet('all', 'c2', 'c1', 'link', 'vulcan', 'pdbs', 'deploy')]
    [String]
    $Target,

    [Switch]
    [alias("x")]
    $X86,

    [Switch]
    [alias("r")]
    $REBUILD
)

$ARCH='amd64'
if ($X86) {
    $ARCH='x86'
}

# perl \\vcwtt\warm\tools\request-ntbuild.pl -toolset d:\jb\msvc -vulcan -comment "CastGuard 10-13" -topicbranch current -flavor "x86fre,amd64fre"
$OS_REPO="D:\os"
$BUILD_DIR="C:\Users\iakronqu\source\msvc"
$BUILD_CMD="src\tools\x86\managed\v4.5\msbuild.cmd /m /p:_BuildArch=$ARCH /p:_BuildType=chk "
$REBUILD_FLAGS=" /t:Rebuild "

$LANGAPI="$BUILD_DIR\src\vctools\langapi\dirs.proj"
$C2="$BUILD_DIR\src\vctools\Compiler\Utc\dirs.proj"
$C1xx="$BUILD_DIR\src\vctools\Compiler\CxxFE\dirs.proj"
$CRT="$BUILD_DIR\src\vctools\crt\dirs.proj"
$LINK="$BUILD_DIR\src\vctools\Link\dirs.proj"
$VULCAN="$BUILD_DIR\src\vctools\StaticAnalysis\Vulcan\dirs.proj"
$PDBS="$BUILD_DIR\src\vctools\PDB\dirs.proj"

$ALL="$LINK",
      "$C2",
      "$C1xx",
      "$CRT",
      "$PDBS",
      "$LANGAPI",
      "$VULCAN"

$DEPS = @()

function Log($msg) {
    Write-Host $msg -Foregroundcolor Yellow
}

function BuildDirs($dirs) {
    pushd $BUILD_DIR
    ForEach ($dir in $dirs) {
        BuildDir $dir
    }
    popd
}

function BuildDir($dirname) {
    Log "Building $dirname"
    $buildcmd = $BUILD_CMD
    if ($REBUILD) {
        $buildcmd += $REBUILD_FLAGS
    }
    $chkness = 'fre'
    if ($dirname -Eq $C2) {
        $chkness = 'chk'
    }
    $buildcmd += "/p:_BuildType=$chkness "
    $buildcmd += " $dirname "
    echo $buildcmd
    invoke-expression $buildcmd
    if ($LASTEXITCODE) {
        Write-Host -ForegroundColor Red ("Error building $dirname 0x{0:x} " -f $LASTEXITCODE)
        echo $buildcmd
        exit -1
    }
}

switch ($Target) {
    'all' { $DEPS = $ALL }
    'c2' { $DEPS += $C2 }
    'c1' { $DEPS += $C1xx }
    'link' { $DEPS += $LINK }
    'crt' { $DEPS += $CRT }
    'vulcan' { $DEPS += $VULCAN }
    'pdbs' { $DEPS += $PDBS }
    'deploy' {
        #perl \\vcwtt\warm\tools\request-ntbuild.pl -toolset d -vulcan -comment "CastGuard (Get-Date -format 'MM-dd')" -topicbranch current -flavor "x86fre,amd64fre"
        echo "run razzle and then the perl script..."
        exit
    }
}

BuildDirs $DEPS
