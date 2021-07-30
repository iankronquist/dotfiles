call "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Enterprise\\VC\\Auxiliary\\Build\\vcvars64.bat"
cd %USERPROFILE%\source\msvc
call .\binaries\amd64chk\setenv.cmd amd64 %cd%\src
title MSVC CastGuard amd64
powershell -NoExit
