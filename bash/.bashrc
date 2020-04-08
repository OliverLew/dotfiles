#!/bin/bash

for p in "$HOME/.gem/ruby" "$HOME/.local/bin" "$HOME/.local/share/npm/bin"
do
    if [ -d "$p" ] && ! echo "$PATH" | grep -q "$p"; then
        export PATH="$p:${PATH}"
    fi
done

if [ "$PS1" ] && [ -f /usr/share/bash-completion/bash_completion ]
then
    . /usr/share/bash-completion/bash_completion
fi

# Environments
export EDITOR=vim
export VISUAL=vim
export NOTES_DIRECTORY="$HOME/Code/notes"
export FBFONT="/usr/share/kbd/consolefonts/ter-216n.psf.gz"

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE=-
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/ipython"
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME/Mathematica"
export PASSWORD_STORE_DIR="$XDG_CONFIG_HOME/password-store"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd"
export ABDUCO_SOCKET_DIR="$XDG_RUNTIME_DIR"
export HISTFILE="$XDG_DATA_HOME/bash_history"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
export MYGVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
export EXINIT=":source $XDG_CONFIG_HOME/ex/exrc"
export VIMINIT=":source $MYVIMRC"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export RANDFILE="$XDG_CACHE_HOME/openssl_rnd"

# Alias
# auto color
alias ls="ls --color=auto"
alias grep="grep --color=auto"
# ask when replacing files
alias mv="mv -i"
alias cp="cp -i"
# do not show *tmpfs
alias df="df -h -x tmpfs -x devtmpfs --output=source,fstype,size,used,avail,pcent,target"
# mpv under virtual console using drm
alias cmpv="mpv --vo=gpu --gpu-context=drm --hwdec=vaapi --drm-drmprime-video-plane=0"
# vcsi alias with template
alias vcsi="vcsi -t --template \$HOME/.config/vcsi/template.txt"
# fzf integrate with pacman and yay
fzfpacman() {
    pacman -Slq | fzf -m -q "$*" --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}
fzfyay() {
    yay -Slq | fzf -m -q "$*" --preview 'yay -Si {1}'| xargs -ro yay -S
}

# Console color theme, reuse .Xresources definitions
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    sed -n "$_SEDCMD" "$HOME/.Xresources" \
    | while read -r n color; do
        if [ "$n" -lt 16 ]; then
            printf "\e]P%X%s" "$n" "$color"
        fi
    done
    clear
fi

# shell prompt functions
__cwd_trim() {
    limit=20
    cwd=$(basename "$PWD")
    if [ ${#cwd} -gt $limit ]
    then
        printf "\[\e[1;33m\]%s ...\[\e[0m\]" "$(echo "$cwd" | cut -c -"$((limit - 4))")"
    else
        printf "\[\e[1;33m\]%s\[\e[0m\]" "$cwd"
    fi
}

__jobs_count() {
    jobs_info=$(jobs)
    count_stop=$(echo "$jobs_info" | grep -Ec "Stopped|Suspended")
    count_run=$(echo "$jobs_info" | grep -Ec "Running")
    count_done=$(echo "$jobs_info" | grep -Ec "Done")
    count_kill=$(echo "$jobs_info" | grep -Ec "Killed|Terminated")
    count=$(( count_stop + count_run + count_done + count_kill ))
    if [ $count -gt 0 ]
    then
        printf " "
        [ "$count_stop" -gt 0 ] && printf "\[\e[33m\]S%s\[\e[0m\]" "$count_stop"
        [ "$count_run"  -gt 0 ] && printf "\[\e[32m\]R%s\[\e[0m\]" "$count_run"
        [ "$count_done" -gt 0 ] && printf "\[\e[34m\]D%s\[\e[0m\]" "$count_done"
        [ "$count_kill" -gt 0 ] && printf "\[\e[31m\]K%s\[\e[0m\]" "$count_kill"
    fi
}

__user_host() {
    printf "\[\e[35m\]%s@%s\[\e[0m\] " "$(whoami)" "$(hostname)"
}

__ssh_indicator() {
    if [ -n "$SSH_CLIENT" ]; then
        printf "\[\e[36m\][SSH]\[\e[0m\] "
        __user_host
    fi
}

__git_autostats() {
    if [ -f /tmp/git-autostats ]; then
        OLDIFS=$IFS
        unset IFS
        read -r uptodate ahead behind conflict < /tmp/git-autostats
        IFS=$OLDIFS
        printf " ["
        [ "$uptodate" -gt 0 ] && printf "\[\e[34m\]%s=\[\e[0m\]" "$uptodate"
        [ "$ahead"    -gt 0 ] && printf "\[\e[32m\]%s+\[\e[0m\]" "$ahead"
        [ "$behind"   -gt 0 ] && printf "\[\e[33m\]%s-\[\e[0m\]" "$behind"
        [ "$conflict" -gt 0 ] && printf "\[\e[31m\]%s±\[\e[0m\]" "$conflict"
        printf "]"
    else
        git autostats -u > /dev/null 2>&1
    fi
}

__before_git() {
    __ssh_indicator
    __cwd_trim
    __jobs_count
    __git_autostats
}
__after_git() {
    printf " \[\e[1;33m\]\$\[\e[0m\] "
}

# use the prompt script somes with git
if ! command -v __git_ps1 > /dev/null 2>&1; then
    . /usr/share/git/completion/git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "$(__before_git)" "$(__after_git)"'

# History, https://unix.stackexchange.com/questions/18212
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Disable ctrl-s and ctrl-q
stty -ixon
# set vi mode keybinding
