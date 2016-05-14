xrdb -merge .Xresources
synclient HorizEdgeScroll=1
xmodmap .Xmodmap

eval $(ssh-agent)

# xset [r rate delay [rate]]
xset r rate 200 25
exec i3
