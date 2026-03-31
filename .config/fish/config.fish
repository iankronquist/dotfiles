if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias vt='vim -t'
alias v='vim -p'

alias l=ls

alias py=python3
alias py2=python2
alias py3=python3
alias pdb='python3 -m pdb -c continue'
# typos
alias py4=python3

alias s='rg -n'
alias si='rg -in'

export XCODE_SDK=$XCODE_IPHONE_SDK

alias mrun="xcrun -sdk $XCODE_MAC_SDK"
alias irun="xcrun -sdk $XCODE_IPHONE_SDK"


