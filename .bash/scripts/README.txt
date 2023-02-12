=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
About
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

This directory contains executable files (e.g. .sh scripts) that can be run directly by bash without the need to source them.

To do this, simply append this location to your path, e.g. if you copied this folder at ~ do:
PATH=${PATH}:~/.bash/scripts

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Instructions
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Follow the guidelines below:
    * Requirements (packages) must be listed at the top of each file as follows:
      ### Requirements
      # jq
      # etc
    * If the executable is a bash script, _ must predede the name of each function, e.g.
      _img2avi
    * If the executable is a bash script, at the end you must call your final function as:
      _do_something $@
