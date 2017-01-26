#!/usr/bin/env bash

alias d=ls
alias ls='ls -G'
alias ll='ls -la'

# don't remember who needed this one
# export ARCHFLAGS='-arch i386 -arch x86_64'

# enable all bash completions that are out there
if [ -f "$(brew --prefix)"/etc/bash_completion ]; then
    . "$(brew --prefix)"/etc/bash_completion
fi

for file in /usr/local/etc/bash_completion.d/*{.sh,.bash}; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done

for file in $HOME/.bash_completions/*.sh; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done


alias vless=/usr/local/share/vim/vim74/macros/less.sh
alias xgettext=/usr/bin/xgettext.pl
alias mp='mplayer -forceidx'
alias ctop='top -o cpu'
alias mtop='top -o vsize'
alias git-pep8='git status -s | grep -v tests | cut -f 3 -d " " | xargs pep8 --max-line-length=120'
alias gti='git'
alias buuc='brew update && brew upgrade && brew cleanup'
alias spip='sudo -H pip'

alias wttr='curl wttr.in'

alias activate='. ./env/bin/activate'
alias reactivate='deactivate && activate'

export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8
export EDITOR=/usr/local/bin/vim

# ignore shellcheck not being able to follow non-constant-source
export SHELLCHECK_OPTS="-e SC1090"

alias pg_restart="pg_ctl -D /usr/local/var/postgres/ restart -p /usr/local/opt/postgresql-9.4/bin/postgres"
alias pg_stop="pg_ctl -m fast -D /usr/local/var/postgres/ stop"

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/usr/local/git/bin:/usr/local/sbin:$PATH
PATH=$HOME/bin:$PATH
PATH=/usr/local/opt/postgresql-9.4/bin:$PATH
export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
export PATH

export GOMAXPROCS=8
export CFLAGS="-std=gnu11 -Wall -g"
export HISTCONTROL="ignoreboth:erasedups"

alias clstc='./manage.py assets build --parse-templates && ./manage.py collectstatic --noinput && printf "\a"'
alias gti=git

# shortcut that removes .pyc files
function rmpyc {
    find "${@:-.}" -name '*pyc' -delete
}

# shortcuts for pycscope generation
function pcs {
    pycscope -R -f .cscope.db "${@:-'.'}"
}
alias pycs=pcs

function srvrs {
    cwd="$(pwd)"
    pushd /tmp

    if [ -z "$(pidof nginx)" ]
    then
        echo "Starting ngnix"
        sudo nginx
    fi
    if [ -z "$(pidof redis-server)" ]
    then
        echo "Starting redis"
        redis-server /usr/local/etc/redis.conf 1>/dev/null 2>&1 &
    fi
    echo "Starting pg"
    pg_restart -s -l /tmp/pg_log.log
    popd "$cwd"
    printf "\a"
}

# include current git branch into PS1
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}
PS1='\[\e[1;34m\]\u \[\e[1;32m\]\W \[\e[1;33m\]$(parse_git_branch)\$\[\e[0m\] '
PS1='\[\e[1;34m\]\u \[\e[1;32m\]\W \[\e[1;33m\]$(__git_ps1)\$\[\e[0m\] '

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=''
export GIT_PS1_SHOWUPSTREAM="verbose"
# print $ in if smth is stashed
export GIT_PS1_SHOWSTASHSTATE=1

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_HIDE_IF_PWD_IGNORED=1

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
        source $env/bin/activate
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

# shortcut to run command by master client
alias murc="PYTHONPATH=/Users/teferi/murano/python-muranoclient python /Users/teferi/murano/python-muranoclient/muranoclient/shell.py"

toxenv() {
    . ".tox/$1/bin/activate"
}

# common mistypes
alias св=cd
alias мшь=vim

# murano
alias murano-api="tox -e venv -- murano-api --config-file ./etc/murano/murano.conf"
alias murano-engine="tox -e venv -- murano-engine --config-file ./etc/murano/murano.conf"
alias murano-syncdb="tox -e venv -- python manage.py syncdb --noinput"
alias murano-dash="tox -e venv -- python manage.py collectstatic --noinput && tox -e venv -- python manage.py runserver"
alias murano-dash-compress="tox -e venv -- python manage.py compress --force  && tox -e venv -- python manage.py collectstatic --noinput && tox -e venv -- python manage.py runserver"

# glance/glare
alias glance-glare="glance-glare --config-file ./etc/glance-glare.conf"

tenv() {
  source ".tox/${1:-venv}/bin/activate"
}

fortune proverbaro | ponysay -r GROUP=mane -r NAME=djpon3 -r NAME=octavia -r NAME=Derpy -b unicode
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

alias vim="vim -O"
