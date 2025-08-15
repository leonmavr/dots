#!/bin/bash

### About
# Adds current directory to the PATH. This way, you can use local binary files
# without adding them to the root, e.g. at /usr/bin.
### Instructions
# Source this script

function _add_dir_to_path() {
    # directories in PATH are delimited with :my/dir: so we match this way
    [[ ":$PATH:" == *":$(pwd):"* ]] || export PATH="$PATH:$(pwd)"
}

_add_dir_to_path
