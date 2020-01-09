#!/bin/sh

alias d=ls
alias ls='ls -G'
alias ll='ls -la'

alias vless=/usr/local/share/vim/vim74/macros/less.sh
alias xgettext=/usr/bin/xgettext.pl
alias mp='mplayer -forceidx'
alias ctop='top -o cpu'
alias mtop='top -o vsize'
alias git-pep8='git status -s | grep -v tests | cut -f 3 -d " " | xargs pep8 --max-line-length=120'
alias gti='git'
alias gut='git'
alias gti='git'
alias buuc='brew update && brew upgrade && brew cleanup'
alias spip='sudo -H pip'

alias wttr='curl wttr.in'
alias weather=wttr

alias activate='. ./env/bin/activate'
alias reactivate='deactivate && activate'

alias pg_restart="pg_ctl -D /usr/local/var/postgres/ restart -p /usr/local/opt/postgresql-9.4/bin/postgres"
alias pg_stop="pg_ctl -m fast -D /usr/local/var/postgres/ stop"

# common mistypes
alias св=cd
alias мшь=vim
alias vim="vim -O"
alias ыыр="ssh"
alias фкс=arc

export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8
export EDITOR=/usr/local/bin/vim

# ignore shellcheck not being able to follow non-constant-source
export SHELLCHECK_OPTS="-e SC1090"

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/usr/local/sbin:$PATH
PATH=$HOME/bin:$PATH
export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
export PATH

export GOMAXPROCS=8
export CFLAGS="-Wall -g"

# shortcut that removes .pyc files
rmpyc() {
    find "${@:-.}" -name '*pyc' -delete
}

# shortcuts for pycscope generation
pcs() {
    pycscope -R -f .cscope.db "${@:-'.'}"
}
alias pycs=pcs

export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=''
export GIT_PS1_SHOWUPSTREAM="verbose"

# check if there is a venv and activate it
check_virtualenv() {
    env=""
    if [ -r .venv ]; then
        env=$(cat .venv)
    fi

    if [ -d env ] && [ -r env/bin/activate ]; then
        env="env"
    fi

    if [ "$env" ]; then
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
# shellcheck disable=SC1117
alias stripcol="perl -pe 's/\e\[?.*?[\@-~]//g'"
alias select1="stripcol | cut -f 1 -d ' '"
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

alias ctags='$(brew --prefix)/bin/ctags'

export PATH="/usr/local/opt/node@10/bin:$PATH"
export PATH="/usr/local/opt/perl@5.18/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/node@10/lib"
export CPPFLAGS="-I/usr/local/opt/node@10/include"
export PATH="/usr/local/opt/qt/bin:$PATH"

if [ -f "$HOME/.tokens" ]; then
    . "$HOME/.tokens";
fi
