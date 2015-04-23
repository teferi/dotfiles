#!/usr/bin/env bash
_fab()
{
    local cur commands
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    commands=$(for x in $(fab --list | tr -s ' ' | cut -f 2 -d ' '| grep -v commands); do echo "${x}" ; done)
    COMPREPLY=( $(compgen -W "${commands}" -- "${cur}") )
    return 0
}
complete -F _fab fab


