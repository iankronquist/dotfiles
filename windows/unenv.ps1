Param(
        [String]
        $str
     )

$ExecutionContext.InvokeCommand.ExpandString(($str -replace "%(.*?)%", '$env:$1'))
