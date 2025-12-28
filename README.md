# dotfiles

Personal dotfiles for macOS, Linux, and WSL.

## Structure

```
dotfiles/
├── install.sh          # Main installer (symlinks + platform setup)
├── zsh/
│   └── .zshrc          # Zsh configuration
├── git/
│   └── .gitconfig      # Git configuration
├── starship/
│   └── starship.toml   # Starship prompt config
├── ssh/
│   └── config          # SSH config template
└── scripts/
    ├── linux.sh        # Linux/WSL package installer
    └── macos.sh        # macOS package installer
```

## Quick Start

```bash
git clone https://github.com/tmsjngx0/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer will:
1. Symlink all config files to their proper locations
2. Back up existing files (with timestamp)
3. Optionally run the platform-specific installer

## What Gets Installed

### Symlinks Created
| Source | Destination |
|--------|-------------|
| `zsh/.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `ssh/config` | `~/.ssh/config` |

### Platform Installers

Both Linux and macOS installers are interactive - they'll ask before installing each component.

**Tools installed:**
- Shell: zsh, oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting
- Prompt: starship
- Editor: neovim
- Node: fnm + LTS
- Python: uv
- .NET: 8, 9, 10
- Docker
- CLI: ripgrep, fd, fzf, jq, lazygit, zellij
- GitHub CLI, Azure CLI
- Claude Code

## Manual Setup

After running the installer:

1. **Restart terminal** or run `exec zsh`
2. **GitHub CLI**: `gh auth login`
3. **Azure CLI**: `az login`
4. **SSH keys** (if needed):
   ```bash
   ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_github
   ssh-add ~/.ssh/id_github
   cat ~/.ssh/id_github.pub  # Add to GitHub
   ```

## Customization

Edit the config files directly in this repo. Changes take effect immediately since files are symlinked.

To add machine-specific settings without modifying tracked files, create `~/.zshrc.local` and source it from `.zshrc`.
