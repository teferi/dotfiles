#!/bin/bash

if [ -f ~/.profile ]; then
    . ~/.profile
fi

export HISTCONTROL="ignoreboth:erasedups"

fortune | ponysay -b unicode
