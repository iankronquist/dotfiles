
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
        $WSLify
     )

  <#
  .SYNOPSIS
  Naively reformats path separators
  Useful for converting a path on the command line to something which can be
  put in a C-style string literal, or another style of path for poorly written
  tools which choke on the wrong type of path.

  .DESCRIPTION
  This function queries the speculation control settings for the system.

  .PARAMETER path
  The path to escape. By default, all backslashes will be escaped by a
  backslash.

  .PARAMETER Unixify
  Given a windows-style path, format it as a unix-style path by replacing all
  backslashes with forward slashes.
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
} else {
    $path -replace "\\", "\\"
}
