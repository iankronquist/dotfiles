if ($args[0] -eq 'clean' -OR $args[0] -eq 'c') {
    $buildcmd ="build -cZh /skiptestcode /DirInclude:!test /nosqm"
} else {
    $buildcmd ="build -h /skiptestcode /DirInclude:!test /nosqm"
}

if ($arch -Eq 'x86') {
    $kernel = 'ntoskrnl.exe'
} elseif ($arch -Eq 'amd64') {
    $kernel = 'ntkrnlmp.exe'
} else {
    echo "Bad arch: '$arch'"
    exit -1
}

function BuildDir($dirname) {
    echo "Building $dirname"
    pushd $dirname
    invoke-expression $buildcmd
    popd
}

function Sign() {
    pushd $sdxroot\..\bin\$flavor
    ntsign $kernel
    ntsign /h:Page ntdll.dll
    ntsign /h:Page kernelbase.dll
    cp $kernel C:\vmshare\ntos\
    cp .\ntdll.dll C:\vmshare\ntos
    cp .\kernelbase.dll C:\vmshare\ntos
    popd
}



BuildDir $sdxroot\minkernel\published
BuildDir $sdxroot\minkernel\apiset
BuildDir $sdxroot\minkernel\ntdll
BuildDir $sdxroot\minkernel\kernelbase
BuildDir $sdxroot\minkernel\ntos

BuildDir $sdxroot\mincore\kernelbase

Sign

Send-MailMessage -To "Ian <iakronqu@microsoft.com>" -From "Razzle <iakronqu@microsoft.com>" -Subject "NTOS Razzle build completed $flavor $sdxroot" -SmtpServer  "smtphost.redmond.corp.microsoft.com"
