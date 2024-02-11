#!/bin/sh

alias d=ls
alias ls='ls -G'
alias ll='ls -la'

alias ctop='top -o cpu'
alias mtop='top -o vsize'
alias gti='git'
alias gut='git'
alias gti='git'
alias buuca='brew update && brew upgrade && brew cleanup && brew autoremove'

alias activate='. ./env/bin/activate'
alias reactivate='deactivate && activate'

# common mistypes
alias св=cd
alias мшь=vim
alias vim="vim -O"
alias ыыр="ssh"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ignore shellcheck not being able to follow non-constant-source
export SHELLCHECK_OPTS="-e SC1090"

PATH=$HOME/bin:$PATH
export PATH

export GOMAXPROCS=8
export CFLAGS="-Wall -g"

# shortcut that removes .pyc files
rmpyc() {
    find "${@:-.}" -name '*pyc' -delete
}

export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
export GIT_PS1_SHOWCOLORHINTS=""
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=''
export GIT_PS1_SHOWUPSTREAM="verbose"
PS1='\[\e[1;34m\]\u \[\e[1;32m\]\W \[\e[1;33m\]$(__git_ps1 "(%s)")\$\[\e[0m\] '


# check if there is a venv and activate it
check_virtualenv() {
    env=""
    if [ -d .venv ]; then
        env=.venv
    elif [ -d venv ]; then
        env=venv
    fi

    if [ ! -z "$env" ] && [ -r "$env/bin/activate" ];  then
        if [ "$VIRTUAL_ENV" ]; then
            deactivate
        fi
        echo "Activating virtualenv '${env}'"
        . $env/bin/activate
    fi
}

venv_cd () {
    builtin cd "$@" && check_virtualenv
}

# Call check_virtualenv in case opening directly into a directory (e.g
# when opening a new tab in Terminal.app).
check_virtualenv

alias cd="venv_cd"

# git-review helper functions
gitr(){
    selecta_args="${2:-}"
    if [ "$selecta_args" ]; then
        selecta_args="-s $selecta_args"
    fi
    git review "$1" "$(git review -l | selecta "$selecta_args" | select1)"
}

# gitrd/gitrx
gitrd() {
    gitr "-d" "$1"
}
gitrx() {
    gitr "-x" "$1"
}

# Platform-specific variables and tokens
if [ -f "$HOME/.tokens" ]; then
    . "$HOME/.tokens";
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# generated with brew shellenv bash
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

if type brew &>/dev/null
then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

export EDITOR="$HOMEBREW_PREFIX/bin/vim"
