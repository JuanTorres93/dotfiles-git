#!/bin/bash

PATH_TO_GENERAL_REFERENCE_FILES="/home/juan/hdd/GTD/General-reference-files/"
thunar "$PATH_TO_GENERAL_REFERENCE_FILES" &
# Open index in a terminarl
alacritty --working-directory "$PATH_TO_GENERAL_REFERENCE_FILES" -e bash -c "tree -C | less -R"




