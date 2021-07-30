call "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Enterprise\\VC\\Auxiliary\\Build\\vcvars32.bat"
cd %USERPROFILE%\source\msvc
call .\binaries\x86chk\setenv.cmd x86 %cd%\src
title MSVC CastGuard x86
powershell -NoExit
