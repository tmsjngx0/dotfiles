# Dev Environment Sync

Analyze the current development environment against the documented requirements and install missing packages.

## Process Overview

```
1. Read package manifest (packages/linux.md or packages/macos.md)
2. Run diagnostic commands to check current state
3. Compare against manifest → generate delta report
4. Install missing packages (grouped by method)
5. Verify installation
6. Update manifest with scan date
```

## Instructions

### Step 1: Read Package Manifest

- Linux/WSL: `packages/linux.md`
- macOS: `packages/macos.md`
- Windows: `packages/windows.md`

Note the Required vs Optional categories.

### Step 2: Run Diagnostic Commands

```bash
# === Core CLI Tools ===
for cmd in git git-lfs gh zsh nvim tmux zellij starship fzf rg lazygit zoxide yazi delta; do
  printf "%-12s: " "$cmd"
  which $cmd 2>/dev/null || echo "MISSING"
done

# fd is 'fdfind' on Ubuntu/Debian
echo -n "fd: " && (which fd 2>/dev/null || which fdfind 2>/dev/null || echo "MISSING")

# === Runtimes ===
for cmd in node bun uv dotnet docker; do
  printf "%-12s: " "$cmd"
  which $cmd 2>/dev/null || echo "MISSING"
done

# === Node Version Manager ===
which fnm 2>/dev/null && fnm --version || echo "fnm: MISSING"
node --version 2>/dev/null || echo "node: MISSING"

# === Cloud & Build Tools ===
for cmd in az claude jq tree curl wget unzip; do
  printf "%-12s: " "$cmd"
  which $cmd 2>/dev/null || echo "MISSING"
done

# === npm Global Packages ===
npm list -g --depth=0 2>/dev/null | grep -E "@anthropic|@fission|codex"

# === Yazi Preview Dependencies ===
for cmd in ffmpeg 7z convert pdftoppm; do
  printf "%-12s: " "$cmd"
  which $cmd 2>/dev/null || echo "MISSING"
done
```

### Step 3: Generate Delta Report

Present findings in table format:

```
## Dev Environment Delta

| Tool | Status | Category | Install Method |
|------|--------|----------|----------------|
| git | OK | Required | apt |
| zoxide | MISSING | Required | apt |
| delta | MISSING | Optional | GitHub release |

### Summary
- Required: X installed, Y missing
- Optional: X installed, Y missing
```

### Step 4: Install Missing Packages

Group by installation method and install in order:

#### 4.1 APT Packages (system)
```bash
sudo apt update && sudo apt install -y \
  build-essential curl wget ca-certificates git git-lfs unzip zip \
  pkg-config software-properties-common htop tree jq ripgrep fd-find \
  fzf zoxide zsh tmux openjdk-8-jdk
```

#### 4.2 GitHub CLI (needs repo setup)
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
```

#### 4.3 Curl Install Scripts
```bash
# Starship prompt
curl -sS https://starship.rs/install.sh | sh -s -- -y

# fnm (Node version manager)
curl -fsSL https://fnm.vercel.app/install | bash
# Then: fnm install --lts && fnm default <version>

# uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Bun (JS runtime)
curl -fsSL https://bun.sh/install | bash

# .NET
curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
chmod +x /tmp/dotnet-install.sh
/tmp/dotnet-install.sh --channel 8.0
/tmp/dotnet-install.sh --channel 9.0

# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

#### 4.4 GitHub Release Binaries
```bash
# Neovim (latest stable)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
# Add to PATH: export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/v//')
curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
sudo install /tmp/lazygit /usr/local/bin
rm /tmp/lazygit /tmp/lazygit.tar.gz

# zellij
curl -Lo /tmp/zellij.tar.gz https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar xf /tmp/zellij.tar.gz -C /tmp
sudo install /tmp/zellij /usr/local/bin
rm /tmp/zellij /tmp/zellij.tar.gz

# yazi
YAZI_VERSION=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | jq -r '.tag_name')
curl -Lo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-musl.zip"
unzip -o /tmp/yazi.zip -d /tmp
sudo install /tmp/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin
sudo install /tmp/yazi-x86_64-unknown-linux-musl/ya /usr/local/bin
rm -rf /tmp/yazi.zip /tmp/yazi-x86_64-unknown-linux-musl

# delta
DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | jq -r '.tag_name')
curl -Lo /tmp/delta.tar.gz "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
tar xf /tmp/delta.tar.gz -C /tmp
sudo install /tmp/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta /usr/local/bin
rm -rf /tmp/delta.tar.gz /tmp/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu
```

#### 4.5 npm Global Packages
```bash
# After fnm/node is installed
npm install -g @anthropic-ai/claude-code
npm install -g @fission-ai/openspec
npm install -g @openai/codex  # optional
```

#### 4.6 Yazi Preview Dependencies (optional)
```bash
sudo apt install -y ffmpeg p7zip-full poppler-utils imagemagick
```

### Step 5: Shell Configuration

After installation, ensure these are in `~/.zshrc`:

```bash
# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# Starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# .NET
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Neovim (if installed to /opt)
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

### Step 6: Post-Install Verification

Re-run Step 2 diagnostics to confirm all tools installed.

### Step 7: Update Manifest

Update the "Last scanned" date in the package manifest.

## Installation Order (Dependencies)

1. **APT packages first** - base system tools, curl, jq needed for later steps
2. **GitHub CLI** - needs apt repo setup
3. **fnm + Node** - needed before npm packages
4. **Curl scripts** - starship, uv, bun, dotnet, docker
5. **GitHub releases** - nvim, lazygit, zellij, yazi, delta
6. **npm packages** - claude-code, openspec (requires Node)
7. **Optional deps** - yazi previews

## Platform Notes

### Linux/WSL
- `fd` is packaged as `fd-find`, binary is `fdfind`
- Neovim from apt is outdated; use GitHub release
- WSL may need `wslu` package for Windows integration

### macOS
- Use Homebrew for most packages: `brew install <package>`
- See `scripts/macos.sh` for specifics

## Troubleshooting

### fnm not loading
Ensure `eval "$(fnm env)"` is in your shell config and restart terminal.

### Node packages not found after install
Run `fnm use default` or restart terminal to pick up fnm PATH.

### Permission denied on /usr/local/bin
Use `sudo install` for GitHub release binaries.
