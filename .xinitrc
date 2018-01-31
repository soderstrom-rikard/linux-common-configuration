[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xset -b b off
xsetroot -solid black
exec awesome
