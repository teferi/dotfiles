#!/bin/bash

if [ -f ~/.profile ]; then
    . ~/.profile
fi

fortune | ponysay -b unicode
