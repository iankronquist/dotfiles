
rm -f tags
/opt/homebrew/bin/ctags \
    --exclude=@.gitignore \
    --exclude=@$HOME/.gitignore \
    '--exclude=.mypy_cache*' \
    '--exclude=*DerivedData*' \
    '--langdef=Swift' \
    '--langmap=Swift:+.swift' \
    '--regex-swift=/(var|let)[ \t]+([^:=]+).*$/\2/v,variable/' \
    '--regex-swift=/func[ \t]+([^\(\)]+)\(/\1/f,function,functions/' \
    '--regex-swift=/class[ \t]+([^:\{]+).*$/\1/c,class/' \
    '--regex-swift=/struct[ \t]+([^:\{]+).*$/\1/s,struct/' \
    '--regex-swift=/protocol[ \t]+([^:\{]+).*$/\1/p,protocol/' \
    '--regex-swift=/enum[ \t]+([^:\{]+).*$/\1/e,enum/' \
    '--regex-swift=/^[ \t]*typealias[ \t]+([^:\{]+).*$/\1/t,typealias,typealias/' \
    '--regex-swift=/^[ \t]*extension[ \t]+([^:\{]+).*$/\1/X,extension,extensions/' \
    '--langdef=Tightbeam' \
    '--langmap=Tightbeam:+.tightbeam' \
    '--regex-tightbeam=/(var|let)[ \t]+([^:=]+).*$/\2/v,variable/' \
    '--regex-tightbeam=/func[ \t]+([^\(\)]+)\(/\1/f,function,functions/' \
    '--regex-tightbeam=/service[ \t]+([^:\{]+).*$/\1/S,service/' \
    '--regex-tightbeam=/component[ \t]+([^:\{]+).*$/\1/C,component/' \
    '--regex-tightbeam=/struct[ \t]+([^:\{]+).*$/\1/s,struct/' \
    '--regex-tightbeam=/enum[ \t]+([^:\{]+).*$/\1/e,enum/' \
    $@ \
    --recurse . 

    #'--regex-swift=/[[:<:]]typealias[[:>:]][[:space:]]+([[:alnum:]_]+)/\1/t,typedef/' \

