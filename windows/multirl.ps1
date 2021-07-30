$flags="/O2 /GL /Zi","/GL /Zi","Pogo:/O2 /GL /Zi"
$repo='C:\Users\iakronqu\source\msvc'
$regress='src\qa\BE\Regress'
$path="$repo\$regress"

pushd $path

#$env:_LINK_='/d2:-CastGuard:3 /d2:-CastGuardMultiCheck'
$env:_LINK_='/d2:-CastGuard:3 /d2:-CxxSafeCastMultiCheck'

ForEach ($flagset in $flags) {
    rl -all -exe -exeflags:"$flagset" -target:amd64
    $timestamp=(get-date -uformat '%Y-%m-%d-%H%M')
    Get-ChildItem rl.*.log | ForEach-Object {
        cp $_ $timestamp-$_.name
    }
}

popd
