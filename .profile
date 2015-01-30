#!/usr/bin/env bash
alias d=ls
alias ls='ls -G'
alias ll='ls -la'
export ARCHFLAGS='-arch i386 -arch x86_64'

if [ -f "$(brew --prefix)"/etc/bash_completion ]; then
    . "$(brew --prefix)"/etc/bash_completion
fi

if [ -f "$HOME/.bash_completion.sh" ]; then
    . "$HOME/.bash_completion.sh"
fi

if [ -f "$HOME/.git-completion.bash " ]; then
    . "$HOME/.git-completion.bash"
fi

alias vless=/usr/local/share/vim/vim74/macros/less.sh
alias xgettext=/usr/bin/xgettext.pl
alias mp='mplayer -forceidx'
alias ctop='top -o cpu'
alias mtop='top -o vsize'
alias git-pep8='git status -s | grep -v tests | cut -f 3 -d " " | xargs pep8 --max-line-length=120'

alias activate='. ./env/bin/activate'
alias reactivate='deactivate && activate'

export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8
export EDITOR=/usr/local/bin/vim

alias pg_restart="pg_ctl -D /usr/local/var/postgres/ restart -p /usr/local/opt/postgresql-9.4/bin/postgres"
alias pg_stop="pg_ctl -m fast -D /usr/local/var/postgres/ stop"
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/usr/local/git/bin:/usr/local/sbin:$PATH
PATH=~/bin:$PATH
PATH=/usr/local/opt/postgresql-9.4/bin:$PATH
export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
export PATH
export GOMAXPROCS=8
export JAVA_HOME="$(/usr/libexec/java_home)"
# to compile numpy
# export ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future
export CFLAGS="-std=gnu11 -Wall -g"



alias clstc='./manage.py assets build --parse-templates && ./manage.py collectstatic --noinput && printf "\a"'
alias gti=git

function rmpyc {
    find "${1:-.}" -name '*pyc' -delete
}

function pcs {
    pycscope -R -f .cscope.db "${1:-'.'}"
}
alias pycs=pcs

function ack2vim {
    pattern=$1
    directory=$2
    result="$(ack "$pattern" "$directory" --nogroup --output='+$.' -s | cut -f 1,3 -d ':' | tr ':' ' ')"
    echo "$result";
}

function srvrs {
    cwd="$(pwd)"
    cd /tmp

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
    cd "$cwd"
    printf "\a"
}


parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}
PS1='\[\e[1;34m\]\u \[\e[1;32m\]\W \[\e[1;33m\]$(parse_git_branch)\$\[\e[0m\] '

export LOCAL_PIP_REPO=$HOME/.localpip/packages
alias localpip="pip install --index-url=file://$LOCAL_PIP_REPO/simple"
function pip_pip2pi() {
    pip install "$@" && pip2pi "$LOCAL_PIP_REPO" "$@"
}
alias pi=pip_pip2pi

alias ge="git st --short --porcelain -uno | cut -f 3 -d ' ' | selecta | xargs -o vim"

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
alias mejira='jira-cli --search-jql="project=MYB AND status in (Dev, Test) AND assignee in (currentUser())"'
alias meji='jira-cli --search-jql="project=MYB AND status in (Dev, Test) AND assignee in (currentUser())" --format="#%key — %summary"'
alias mj='meji | selecta | tr -d " " | cut -f 1 -d —'

fortune proverbaro | ponysay -r GROUP=mane -r NAME=djpon3 -r NAME=octavia -r NAME=Derpy -b unicode
