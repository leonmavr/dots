### :large_orange_diamond: About
This repo contains all (working and tested) dotfiles for my Linux setups. The files in the root of this repo should correspond to your home folder. For example, the `.bash` directory should correspond to `~/.bash` in your machine.

### :large_orange_diamond: Managing the dotfiles

It's recommended to manage them with the `stow` package. `stow` manages and creates symlinks. By using `stow` you won't have to copy your local dotfiles to your git repository every time you want to make changes. To install `stow` in Arch:
```
sudo pacman -S stow
```
To install it in Ubuntu:
```
sudo apt-get install stow
```
`stow`'s workflow is:
1. Clone your dotfiles in some location (to a workspace)
2. Use stow to create symlinks from your workspace (e.g. `~/Documents`) to `~`
3. When you edit your dotfiles in the workspace, those in `~` will be symlinked to your workspace therefore automatically updated.
4. When you're done with editing the files in the workspace and you've tested them, you're ready to commit on git!

```
cd ~/Documents
git clone git@github.com:leonmavr/dotfiles.git
cd dotfiles
# or:
# https://github.com/leonmavr/dotfiles.git
```
Suppose we want to manage the `.bash` folder. Then:
```
rm -rf ~/.bash
mkdir ~/.bash
stow --target=/home/$USER/.bash .bash
```
Verify that symlinks were created:
```
cd ~/.bash
ls -l
```
Output:
```
bash_aliases -> ../Documents/dotfiles/.bash/bash_aliases
...
```

### :large_orange_diamond: Managing the branches
* This is the master branch and its contents should be minimum. Master contains only files that can be used independtly of OS and desktop environment, e.g. bash and vim configs.
* Other branches include standalone dotfiles for specific operating systems, mainly for Arch.
* It's there recommended to merge the master into the other branches every once in a while.
