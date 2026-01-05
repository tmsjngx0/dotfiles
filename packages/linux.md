# Linux/WSL Packages

> Last scanned: 2026-01-03 (WSL Ubuntu)

## Required (apt)

```
# CLI essentials
git
git-lfs
gh
fzf
ripgrep
fd-find
jq
tree
zoxide

# Terminal (neovim via bob, zellij/yazi via cargo)
lazygit

# Languages
golang-go

# Build tools
build-essential
curl
wget
unzip

# WSL utilities
wslu
```

## Required (manual/script)

```
# Starship prompt
curl -sS https://starship.rs/install.sh | sh

# fnm (Node.js)
curl -fsSL https://fnm.vercel.app/install | bash

# uv (Python)
curl -LsSf https://astral.sh/uv/install.sh | sh

# .NET
# https://learn.microsoft.com/dotnet/core/install/linux

# Claude Code
npm install -g @anthropic-ai/claude-code

# Rust + cargo-binstall
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-binstall

# Neovim (via bob version manager)
cargo binstall bob-nvim
bob install stable && bob use stable

# Zellij (via cargo binstall - faster than compile)
cargo binstall zellij

# Yazi (terminal file manager)
cargo binstall yazi-fm yazi-cli
```

## Optional

```
docker-ce
delta           # Better git diff viewer

# Cloud CLIs
azure-cli       # https://docs.microsoft.com/cli/azure/install-azure-cli-linux
gcloud-cli      # https://cloud.google.com/sdk/docs/install

# Yazi dependencies (file manager previews)
ffmpeg
7zip
poppler-utils   # PDF preview
imagemagick     # Image preview
w3m             # HTML preview
```

## Currently Installed (2026-01-03)

### Core CLI
- git, git-lfs, gh, zsh, fzf, ripgrep, fd-find, jq, tree, zoxide, tmux

### Terminal Tools (GitHub releases → /usr/local/bin)
- neovim v0.11.5 (→ /opt/nvim-linux-x86_64)
- zellij, lazygit, yazi, delta

### Runtimes
- fnm 1.38.1 + Node v22.21.1
- bun (~/.bun)
- uv (~/.local/bin)
- dotnet 8.0, 9.0

### Cloud CLIs
- az (Azure CLI)
- gh (GitHub CLI)

### npm Global Packages
- @anthropic-ai/claude-code
- @fission-ai/openspec
- @openai/codex
- @fresh-editor/fresh-editor

### Yazi Preview Dependencies
- ffmpeg, 7z, imagemagick, poppler-utils
