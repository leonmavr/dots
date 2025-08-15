#!/bin/bash

### About
# Adds current directory to the PATH. This way, you can use local binary files
# without adding them to the root, e.g. at /usr/bin.
### Instructions
# Source this script

function _add_dir_to_path() {
    current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # directories in PATH are delimited with :my/dir: so we match this way
    [[ ":$PATH:" == *":${current_dir}:"* ]] || export PATH="$PATH:${current_dir}"
}

_add_dir_to_path
