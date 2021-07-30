
Param(
    [String]
    $bin,
    [Switch]
    [alias("r")]
    $reboot
)


$name = (Get-ChildItem $bin).name

Push-Location $env:_NTTREE

$ntsignflags=''
if ($name -eq 'ntdll.dll') {
    $ntsignflags='/h:Page'
}
ntsign $ntsignflags $env:_NTTREE\$name 
putd C:\vmshare\sfpcopy.exe c:\users\tdpuser
putd $env:_NTTREE\$name c:\users\tdpuser
cmdd "C:\Users\tdpuser\sfpcopy.exe c:\users\tdpuser\$name c:\windows\system32\$name"
if ($reboot) {
    #cmdd "shutdown /r /t 0"
    Restart-TestDevice -Verbose #| c:\Users\iakronqu\.vscode\extensions\microsoft.tdpcode-1.7.6\out\extension\SetTdpDevice.ps1
}