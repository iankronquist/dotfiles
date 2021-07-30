Param(
    [parameter(HelpMessage="Show colors!")]
    [Switch]
    [alias("c")]
    $Colors,

    [parameter(HelpMessage="Show full path")]
    [Switch]
    [alias("p")]
    $FullPath

)

function Log() {
    if ($Colors) {
        Write-Host $args
    } else {
        Write-Output $args
    }
}

function LogGreen() {
    if ($Colors) {
        Write-Host -ForegroundColor Green $args
    } else {
        Write-Output $args
    }
}

function LogRed() {
    if ($Colors) {
        Write-Host -ForegroundColor Red $args
    } else {
        Write-Output $args
    }
}

function ShowFileInfo() {
    $file = (Get-ChildItem $args[0])
    if ($file) {
        if ($FullPath) {
            LogGreen ($file.FullName.Trim())
        } else {
            LogGreen ($file.Name.Trim())
        }
        Log ($file.LastWriteTime | Out-String).Trim()
        Log (Get-FileHash $file).Hash
        Log ""
    } else {
        LogRed "file " $args[0] " does not exist"
    }
}

function GetLibraryNames() {
    $re = "(/Z\w\s+|/wholearchive:)(.+?\.lib)"
    $arr = (echo $args | Select-String  -Pattern $re -AllMatches).Matches
    if ($arr) {
        return $arr | foreach-object { $_.Groups[2].Value }
    }
    return @()
}

function GetLibrariesFromEnv() {
    return (GetLibraryNames $env:_CL) + (GetLibraryNames $env:_LINK_)
}

function ShowFilesInfo() {
    LogGreen "From _CL_"
    (GetLibraryNames $env:_CL_) | foreach-object {
        ShowFileInfo $_
    }

    LogGreen "From _LINK_"
    (GetLibraryNames $env:_LINK_) | foreach-object {
        ShowFileInfo $_
    }


    LogGreen "The compiler"
    $Compiler=(Get-Command cl).Path
    ShowFileInfo $Compiler
}

ShowFilesInfo
