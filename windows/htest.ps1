
rtl
build /p

ntdll
build /p

bin
ntsign /h:Page ntdll.dll

open-kd

putd $env:osbuildroot\bin\amd64chk\ntdll.dll c:\
putd C:\vmshare\sfpcopy.exe C:\
putd c:\vmshare\crc32.exe c:\  
cmdd c:\sfpcopy.exe c:\ntdll.dll c:\windows\system32\ntdll.dll

Restart-TestDevice -Verbose | c:\Users\iakronqu\.vscode\extensions\microsoft.tdpcode-1.8.6\out\extension\SetTdpDevice.ps1
