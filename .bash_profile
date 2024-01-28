#!/bin/bash

if [ -f ~/.profile ]; then
    . ~/.profile
fi

# enable all bash completions that are out there
if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then
    . "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

for file in /usr/local/etc/bash_completion.d/*{.sh,.bash}; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done

for file in "$HOME"/.bash_completions/*.sh; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done

export HISTCONTROL="ignoreboth:erasedups"

PS1='\[\e[1;34m\]\u \[\e[1;32m\]\W \[\e[1;33m\]$(__git_ps1 "(%s)")\$\[\e[0m\] '

fortune | ponysay -b unicode
