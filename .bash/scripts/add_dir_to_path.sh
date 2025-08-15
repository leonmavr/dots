#!/bin/bash

### About
# Adds current directory to the PATH. This way, you can use local binary files
# without adding them to the root, e.g. at /usr/bin.
#
### Using it with i3 
# This script is meant to be sourced to add the current `~/.bash/scripts` directory to the PATH variable.
# This is because the i3 windows manager ignores changes made to the environment via .bashrc or .xprofile.
# Therefore every time a keybind that invokes a script in ~/.bash/scripts is activated, the latter directory needs to be manually added to PATH.

function _last_two_dirs() {
    local this_file=`realpath $0`
    local this_abs_dir=${this_file%/*}
    local this_abs_dir_one_up=${this_abs_dir%/*}
    local this_dir=${this_abs_dir##*/}
    local this_dir_one_up=${this_abs_dir_one_up##*/}
    echo $this_dir_one_up/$this_dir
}

# Adds this script's directory to PATH if it's not already found there
function add_dir_to_path() {
    local last_two_dirs=`_last_two_dirs`
    if [[ ! $PATH == *"$last_two_dirs"* ]]; then
        local this_file=`realpath $0`
        local this_abs_dir=${this_file%/*}
        PATH=${PATH}:$this_abs_dir
    fi
}

add_dir_to_path
