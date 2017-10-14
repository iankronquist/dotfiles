xrdb -merge .Xresources
synclient HorizEdgeScroll=1
xmodmap .Xmodmap

eval $(ssh-agent)

# xset [r rate delay [rate]]
xset r rate 200 25

# Set mouse acceleration
# (device 11, property 293, see `xinput list` and `xinput list-props`)
# to a number between -1 and 1.
xinput --set-prop 11 293 .75

exec i3
