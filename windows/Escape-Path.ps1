
Param(
        [String]
        $path,

        [Switch]
        [alias("u")]
        $Unixify,

        [Switch]
        [alias("w")]
        $Windowsify,

        [Switch]
        [alias("s")]
        $WSLify,

        [Switch]
        [alias("r")]
        $URLify
     )

  <#
  .SYNOPSIS
  Naively reformats path separators
  Useful for converting a path on the command line to something which can be
  put in a C-style string literal, or another style of path for poorly written
  tools which choke on the wrong type of path.

  .DESCRIPTION
  This function naively reformats path separators

  .PARAMETER path
  The path to escape. By default, all backslashes will be escaped with a
  backslash.

  .PARAMETER Unixify
  Given a windows-style path, format it as a unix-style path by replacing all
  backslashes with forward slashes. Do not adjust the drive letter, if it
  exists.
  Alias u.

  .PARAMETER Windowsify
  Given a unix-style path, format it as a windows-style path by replacing all
  forward slashes with backslashes.
  Alias w.
  #>



if ($Unixify) {
    $path -replace "\\", "/" #"
} elseif ($Windowsify) {
    $path -replace "/", "\" #"
} elseif ($WSLify) {
    # FIXME should work for drives other than C:
    $path = $path -replace "C:", ""
    $path = $path -replace "\\", "/" #"
    "/mnt/c" + $path
} elseif ($URLify) {
    $path -replace "\\", "%2F" #"
    # FIXME should I use a different escape code for actual forward slashes?
    $path -replace "/", "%2F" #"
} else {
    $path -replace "\\", "\\"
}
