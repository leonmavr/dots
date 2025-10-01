<div align="center"; style="text-align:center; font-size: 48px; line-height: 1; margin: 20px 0; color: orange;">
  &#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;
</div>


### :large_orange_diamond: This Setup

Wecome to my dotfiles.
In this setup, I am using and configuring:

* `Xorg` as my display manager 
* `bash` as the shell
* `nvim` as my editor 
* `ranger` as my file explorer
* Other productivity utilies, such as `fzf` (fuzzy find), `sxiv` (image viewer
within ranger), etc.
* Various command-line scripts to make my life easier.

### :large_orange_diamond: Get Started

#### 1. Overwrite your local rc (e.g `.bashrc` or `.zshrc`)

```bash
cat .bashrc.append >> ~/.bashrc # or whatever rc file you have
```

#### 2. Requirements 

You will need to install the following:

* `nvim`: Install it with your package manager  or from source and make sure the 
version is at least `0.8`.
* `ranger`: Install it with your package manager
* `fzf`: I recommend a full installation but you can skip the flags:
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git /tmp/fzf
cd /tmp/fzf
./install --xdg --key-bindings --completion --update-rc
```

Optionally:

* `dunst` as a notification manager but you can stick with `notify-send`
* `jq` to query json data
* `ffmpeg`
* `imagemagick`
* `xclip` (clipboard)
* `stow` to easily symlink this cloned repo to your local files

#### 3. Copy Configs

You can copy the configs in two ways - manually or with `stow`. `stow` is
a utility to recusively and easily create symlinks from directoties so this way
you don't constantly have to copy between your repo and your local files. Read 
below if you decide to go with `stow`.

Suppose you want to link the nvim config of this repo to your local files, e.g.
at `~/.config/nvim`. If you already have a setup in `~/.config/nvim`, you need
to **delete it** before using stow:

```bash
rm -rf ~/.config/nvim
mkdir -p ~/.config/nvim
cd dots/.config # in this cloned repo
stow -t ~/.config/nvim nvim
# to make sure everything worked:
# ls -l nvim # and you should see something like:
# lrwxrwxrwx 1 user user 38 Sep  9 18:40 init.lua -> ../../dev/dots/.config/nvim/init.lua
```

And that's it, you mirrored you cloned Neovim config into your local files!
You can repeat this process for other any directories of your choice.

#### 4. Post-installation

**TODO**: source the `add_dir_to_path.sh` script

**TODO**: packer update with nvim

### :large_orange_diamond: Screenshots

### :large_orange_diamond: License 

All scripts and files in this repo are released under [kopimi](https://kopimi.com/).
Feel free to copy or play around with them and no credits are needed.

<div align="center">
<img src="https://kopimi.com/badges/kopimi_text.gif" alt="Kopimi logo" style="width:300px;"/>
</div>

<div align="center"; style="text-align:center; font-size: 48px; line-height: 1; margin: 20px 0; color: orange;">
  &#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;
</div>
