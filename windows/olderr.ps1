
$Search = $args[0]

$ErrUrl = 'http://errors/errmsgs.js'
$ErrDbDir = $env:ProgramData + '\Err'
$ErrDb = $ErrDbDir + '\errordb.json'
$TooOldDate = (Get-Date).AddDays(-30)

function log() {
    write-host $args
}

function Refresh-ErrDb() {
    log "Refreshing error db"
    $content = ((Invoke-WebRequest $ErrUrl).Content)
    #echo $content | less
    $json = Parse-ErrJs $content
    if (!(Test-Path -PathType Container $ErrDbDir)) {
        mkdir $ErrDbDir
    }
    log $json
    $json > $ErrDb
    log "Error db refreshed"
    return $json
}

function Parse-ErrJs($js) {
    return ($js | select -skip 1)
}

function Rehydrate-ErrDb() {
    return (Get-Content $ErrDb)
}

function Load-ErrDb() {
    if (!(Test-Path -PathType Leaf $ErrDb) -or (Test-Path $ErrDb -OlderThan $TooOldDate)) {
        return Refresh-ErrDb
    }
    log 'Rehydrating Error DB'
    return Rehydrate-ErrDb
}

function Lookup($search) {
    $ErrList = Load-ErrDb
    log -y
    log $ErrList
    $ErrList = Load-ErrDb | ConvertFrom-Json
    $SearchIsNumeric = $false
    if ($search -match '[\dx\*]+') {
        $SearchIsNumeric = $true
    }

    log '-z'
    log $search
    log 'a'
    log $ErrList

    #for ($item in $ErrList) {
    #    $index = if ($SearchIsNumeric) { 0 } else { 1 }
    #    if ($index -)
    #}
}

Lookup $Search
