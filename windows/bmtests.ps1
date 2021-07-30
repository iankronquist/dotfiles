

$buildcmd ="build -cZh /nosqm"
#$buildcmd ="build -h /nosqm"

function BuildDir($dirname) {
    echo "Building $dirname"
    pushd $dirname
    invoke-expression $buildcmd
    popd
}

function Deploy() {
    pushd $sdxroot\..\bin\$flavor
    rm -r c:\vmshare\OnecoreTest
    cp -r .\OnecoreTest\ c:\vmshare\OnecoreTest
    cp .\NTTEST\commontest\ntlog\ntlogger.ini C:\vmshare\OnecoreTest\kernel\ps\secfg\ntlogger.ini
    cp .\NTTEST\commontest\ntlog.dll C:\vmshare\OnecoreTest\kernel\ps\secfg\ntlog.dll
    popd
}

BuildDir $sdxroot\onecore\base\test\kernel\ps\secfg
#BuildDir $sdxroot\onecore\base\test\kernel\ps\DynamicCodePolicyTests

Deploy
