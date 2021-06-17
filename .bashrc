#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function source_if_exists {
  if [ -f "$1" ]; then
    . "$1"
  fi
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Bash completions /usr/share/bash-completion/completions
complete -cf man
complete -cf sudo
source_if_exists /usr/share/bash-completion/completions/git
source_if_exists /usr/share/bash-completion/completions/journalctl
source_if_exists /usr/share/bash-completion/completions/pacman
source_if_exists /usr/share/bash-completion/completions/systemctl
set completion-query-items 500

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

source_if_exists ~/.bash_aliases

# git prompt configuration
export GIT_PS1_SHOWDIRTYSTATE=true      # Show unstaged (*) and staged (+) changes
export GIT_PS1_SHOWSTASHSTATE=true      # Show stashed ($) changes available
export GIT_PS1_SHOWUNTRACKEDFILES=true  # Show untracked (%) files
export GIT_PS1_SHOWUPSTREAM="auto"      # Show when behind (<), ahead (>), diverged (<>) and same (=)
export GIT_PS1_DESCRIBE_STYLE="branch"  # In detached head state, show relation to closest branch/tag
export GIT_PS1_SHOWCOLORHINTS=true      # Colorize git prompt as "git status -sb"
export GIT_PS1_STATESEPARATOR=':'       # Separator between branch-name and state information
# user specific
BCS="\["                          # Begin Sequence of Non-Printing Characters
ECS="\["                          # End   Sequence of Non-Printing Characters
BLUE="${BCS}\e[38;5;99m${ECS}"
WHITE="${BCS}\e[1;0m${ECS}"
WHITE_BOLD="${BCS}\e[1;37m${ECS}"
DEFAULT="${BCS}\e[0m${ECS}"
HOSTNAME="\h"
TIME="\A"
PROMPT_PRE="${WHITE_BOLD}${HOSTNAME}:${TIME}"
PROMPT_POST="${BLUE}[\w]${WHITE} \r\n>>${DEFAULT}"

export EDITOR=/usr/bin/vim

declare -a GIT_PROMPT_PATHS=(
    /usr/share/git/git-prompt.sh      # Default location
    /etc/bash_completion.d/git-prompt # Default location
    /etc/profile.d/git-prompt.sh      # Git for Windows location
)

export PS1="${PROMPT_PRE}${PROMPT_POST}"
for alternative in ${GIT_PROMPT_PATHS[@]}; do
    if [ -f "$alternative" ]; then
        source "$alternative"
        unset PS1
        export PROMPT_COMMAND='__git_ps1 "${PROMPT_PRE}" "${PROMPT_POST}"'
    fi
done
