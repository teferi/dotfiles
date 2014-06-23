[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
alias d=ls
alias ls='ls -G'
alias ll='ls -la'
export ARCHFLAGS='-arch i386 -arch x86_64'
export PYTHONPATH="/usr/local/Cellar/pil/1.1.7/lib/python2.6/site-packages/:/Users/teferi/lib/:/Users/teferi/git/:$PYTHONPATH"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

if [ -f "$HOME/etc/.bash_completion.sh" ]; then
    . "$HOME/etc/.bash_completion.sh"
fi

alias xgettext=/usr/bin/xgettext.pl
alias mp='mplayer -forceidx'

alias ctop='top -o cpu'
alias mtop='top -o vsize'
alias git-pep8='git status -s | grep -v tests | cut -f 3 -d " " | xargs pep8 --max-line-length=120'
RUBIES=(~/.rvm/rubies/*)

alias spython='/Library/Frameworks/Python.framework/Versions/2.7/bin/python'
alias pythonsys='spython'
# Setting PATH for Python 2.7
# The orginal version is saved in .profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
#export PATH
alias activate='. ./env/bin/activate'
alias reactivate='deactivate && activate'

export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8
export EDITOR=/usr/local/bin/vim

#defaults write com.apple.dashboard mcx-disabled -boolean YES
alias pg_restart="pg_ctl -D /usr/local/var/postgres/ restart"
alias pg_stop="pg_ctl -m fast -D /usr/local/var/postgres/ stop"
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/usr/local/git/bin:/usr/local/sbin:$PATH
export PATH=~/bin:$PATH
export GOPATH=/Users/teferi/go
export PATH=$PATH:$GOPATH/bin
export GOMAXPROCS=8


alias clstc='./manage.py assets build --parse-templates && ./manage.py collectstatic --noinput && printf "\a"'
alias gti=git

function rmpyc {
    d=${1:-'.'};
    find $d -name '*pyc' -delete;
}

function pcs {
    d=${1:-'.'};
    pycscope -R -f .cscope.db $d
}

function ack2vim {
    pattern=$1;
    directory=$2;
    result=$(ack "$pattern" "$directory" --nogroup --output='+$.' -s | cut -f 1,3 -d ':' | tr ':' ' ');
    echo $result;
}

function srvrs {
    cwd=$(pwd)
    cd /tmp

    if [ -z "$(pidof nginx)" ]
    then
        echo "Starting ngnix"
        sudo nginx
    fi
    if [ -z "$(pidof redis-server)" ]
    then
        echo "Starting redis"
        redis-server 1>/dev/null 2>&1 &
    fi
    echo "Starting pg"
    pg_restart -s -l /tmp/pg_log.log
    cd $cwd
    printf "\a"
}

. ~/.git-completion.bash

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}
PS1='\[\e[1;34m\]\u \[\e[1;32m\]\W \[\e[1;33m\]$(parse_git_branch)\$\[\e[0m\] '

alias localpip="pip install --index-url=file://"$LOCAL_PIP_REPO"/simple"
export LOCAL_PIP_REPO=$HOME/.localpip/packages
function pip_pip2pi() {
    pip install "$@" && pip2pi $LOCAL_PIP_REPO "$@"
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

    if [ ! -z "$env" ]; then
        if [ "$env" != "${VIRTUAL_ENV##*/}" ]; then
            echo "Found .venv in directory. Activating ${env}"
            source $env/bin/activate
        fi
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

#set -o vi
fortune proverbaro | ponysay -r GROUP=mane -r GROUP=royal -r NAME=Derpy -b unicode
