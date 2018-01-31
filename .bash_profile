#
# ~/.bash_profile
#

[[ -z $DISPLAY && $XDG_VTNR -le 3 ]] && exec startx
[[ -f ~/.bashrc ]] && . ~/.bashrc
