
rm -f tags
/opt/homebrew/bin/ctags \
    --exclude=@.gitignore \
    --exclude=@$HOME/.gitignore \
    '--exclude=.mypy_cache*' \
    '--exclude=*DerivedData*' \
    '--langdef=Swift' \
    '--langmap=Swift:+.swift' \
    '--regex-swift=/(var|let)[ \t]+([^:=]+).*$/\2/v,variable/' \
    '--regex-swift=/func[ \t]+([^\(\)]+)\([^\(\)]*\)/\1/f,function/' \
    '--regex-swift=/class[ \t]+([^:\{]+).*$/\1/c,class/' \
    '--regex-swift=/protocol[ \t]+([^:\{]+).*$/\1/p,protocol/' \
    --recurse . 

