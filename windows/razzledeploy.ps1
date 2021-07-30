# %OSBuildToolsRoot%\vPack\vPack.exe push /BaseName:DevDiv.feature.VCToolsRelLKG.VCTools1 /Major:19 /Minor:20 /Patch:2672010 /Prerelease:jobialek /Metadata:DevDivTFS.castguardcrt /SourceDirectory:d:\jb\vpack\vccrt "/expirationTime:9/30/2019 23:38:24"
#[2:58 PM] Joe Bialek
#    you need to create a vpack
#?[2:58 PM] Joe Bialek
#    like this
#?[2:58 PM] Joe Bialek
#    %OSBuildToolsRoot%\vPack\vPack.exe push /BaseName:DevDiv.feature.VCToolsRelLKG.VCTools1 /Major:19 /Minor:20 /Patch:2672010 /Prerelease:jobialek /Metadata:DevDivTFS.castguardcrt /SourceDirectory:d:\jb\vpack\vccrt "/expirationTime:9/30/2019 23:38:24"
#?[2:58 PM] Joe Bialek
#    change the minor number and set the experiation time a few months in the future
#?[2:59 PM] Joe Bialek
#    Sorry don't change minor number, change patch number
#?[2:59 PM] Joe Bialek
#    The way I create this vpack is first, I copy d:\jb\os\osdeps\vccrt to the folder d:\jb\vpack\vccrt
#?[2:59 PM] Joe Bialek
#    Then I update hte CRT in the vpack folder that I created
#?[2:59 PM] Joe Bialek
#    Then I create the vpack

$env:OSBuildToolsRoot\vPack\vPack.exe push /BaseName:DevDiv.feature.VCToolsRelLKG.VCTools1 /Major:19 /Minor:20 /Patch:2672011 /Prerelease:iakronqu /Metadata:DevDivTFS.castguardcrt /SourceDirectory:d:\jb\vpack\vccrt "/expirationTime:11/30/2019 23:38:24"
