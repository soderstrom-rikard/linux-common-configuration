#
# ~/.bash_profile
#

[[ -z $DISPLAY && $XDG_VTNR -le 3 ]] && \
[[  -x "$(which startx)"          ]] && \
    exec startx

[[ -f ~/.bashrc ]] && . ~/.bashrc
