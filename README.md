<div align="center"; style="text-align:center; font-size: 48px; line-height: 1; margin: 20px 0; color: orange;">
  &#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;
</div>

My personal Linux setup, configuration files, scripts, and small utilities.

Built around a keyboard-driven workflow for users who mostly live on the
terminal. Lean and efficient, without too many tools to bloat it.

---

### :large_orange_diamond: How to install

Clone the repository:

```bash
git clone https://github.com/leonmavr/dots.git
cd dots
```

#### Bootstrap

###### ⚠ THESE SCRIPTS WILL OVERWRITE YOUR LOCAL `~/.config`! RUN THEM RESPONSIBLY. ⚠


The `bootstrap/` directory contains installers for little programs I commonly use.
No `sudo` is required - it will install all pre-built versions of my tools in 
`~/.local/bin` and the post-installer will make sure that `PATH` points to it.

Run all of the tool installers and then the post-install script, which builds
the bash environment (such as prompt and aliases):

```bash
cd bootstrap
for f in *.sh; do
    [ -f "$f" ] && bash "$f"
done
cd post_install
bash post_install.sh
```

#### Neovim

The Neovim (`nvim`) configuration lives in `.config/nvim`.

Before starting `nvim`, install its external prerequisites.

**Arch-based systems:**

```bash
sudo pacman -S neovim git ripgrep fd clang python python-pip \
    nodejs npm make zathura latexmk
```

**Debian/Ubuntu-based systems:**

```bash
sudo apt install neovim git ripgrep fd-find clang python3 python3-pip \
    nodejs npm make zathura latexmk
```

The configuration also uses `pyright`, `black`, `flake8`, and `debugpy` for Python development:

```bash
sudo npm install -g pyright
pip install black flake8 debugpy
```

Once the prerequisites are installed, `nvim` will already have its config prepared
from the bootstrap. So just launch it:

```bash
nvim
```

On the first launch, `Packer` is automatically cloned into `nvim`'s data 
directory if not already installed. The configuration then syncs the plugins 
automatically.

If the plugins do not install automatically, run:

```vim
:PackerSync
```

That's it, your Neovim setup should be ready to go!

### :large_orange_diamond: My stack

#### Terminal & Shell

* `bash` : shell
* `fzf` : fuzzy finding
* `ripgrep` : fast searching
* `ranger` : file manager with integrated helper scripts
* `jq` : JSON processing
* `dust` : disk usage visualizer

#### Editor

* `neovim` : editor
* `clangd` : C/C++ language server
* `pyright` : Python language server
* `nvim-dap` : debugging
* `telescope`/`fzf` : navigation and search
* `vimtex` : LaTeX workflow

#### Desktop

* `dunst` : notification daemon
* [`coolersxiv`](https://github.com/leonmavr/coolersxiv) : image viewer - fork of sxiv.

#### Development

The environment is mainly geared towards C/C++, Python and typesetting notes with
LaTeX.

---

### :large_orange_diamond: Demos

---

<div align="center">
  <img src="https://kopimi.com/badges/kopimi_text.gif" alt="Kopimi logo" style="width:300px;"/>
</div>

<div align="center"; style="text-align:center; font-size: 48px; line-height: 1; margin: 20px 0; color: orange;">
  &#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;&nbsp;&nbsp;&nbsp;&#x25CF;
</div>

