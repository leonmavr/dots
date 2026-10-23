# Purpose

This directory contains scripts or tools to port the dotfiles in a new machine.

```bash
bash installers/install.sh                 # interactive picker
bash installers/install.sh --dry-run       # preview the plan
bash installers/install.sh --all --yes     # unattended install
bash installers/install.sh --only ranger,fzf,post_install --yes
```

Or, from a fresh machine, let `bootstrap.sh` clone the repository first:

```bash
curl -fsSL https://raw.githubusercontent.com/leonmavr/dots/master/bootstrap/bootstrap.sh | bash
```

Pinned tool versions live in `installers/versions.conf`; shared helpers
(`detect_arch`, `fetch`, `install_bin`, version lookup) live in
`installers/lib.sh`.

Installers only place binaries in `~/.local/bin`. Shell startup lines
(`PATH`, fzf/zoxide hooks) are owned solely by `post_install.sh`, so the
individual installers never touch `~/.bashrc`.
