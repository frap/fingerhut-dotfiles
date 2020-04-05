#!/usr/bin/env bash
# This file is loaded by many shells, including graphical ones.
#load up the bash_prompt - do it here as emacs tramp gets fucked up with
#non > prompts
[ -f "$HOME/.bash_prompt" ] && source "$HOME/.bash_prompt"


# add host customisations in .bash_profile.local
# Don't make edits below this
[ -f "$HOME/.bash_profile.local" ] && source "$HOME/.bash_profile.local"
