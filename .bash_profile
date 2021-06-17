#
# ~/.bash_profile
#

# Disable beep in less
export LESS="$LESS -R -Q"

[[ -z $DISPLAY && $XDG_VTNR -le 3 ]] && \
[[  -x "$(which startx)"          ]] && \
    exec startx

[[ -f ~/.bashrc ]] && . ~/.bashrc
