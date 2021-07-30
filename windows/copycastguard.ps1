# Copy the compiler build binaries to the Windows tools\vc directory
$CompilerBinPath = "C:\Users\iakronqu\source\msvc\binaries"
#$OutputDir = "F:\vpacktest\vc"
$OutputDir = "d:\os\tools\vc"
$Flavor = "chk"     #chk or ret
$BinName = "c2.dll"

$SubpathPairs = @(
@("\amd64$($Flavor)\bin\amd64\", "\HostX64\amd64"), 
@("\x86$($Flavor)\bin\x86_amd64\", "\HostX86\amd64"),
@("\amd64$($Flavor)\bin\amd64_x86\", "\HostX64\x86"),
@("\x86$($Flavor)\bin\i386\", "\HostX86\x86")
)
foreach ($SubpathPair in $SubpathPairs)
{
    $CompilerSubPath = $SubpathPair[0]
    $WindowsSubPath = $SubpathPair[1]
    Copy-Item "$($CompilerBinPath)\$($CompilerSubPath)\$($BinName)" "$($OutputDir)\$($WindowsSubPath)\$($BinName)"
    #Remove-Item "$($OutputDir)\$($WindowsSubPath)\$($BinName)"
}

