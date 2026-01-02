#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if command exists
is_installed() {
    command -v "$1" &> /dev/null
}

# Ask y/n
ask() {
    local prompt=$1
    local default=${2:-n}

    if [[ "$default" == "y" ]]; then
        echo -e -n "${YELLOW}$prompt [Y/n]: ${NC}"
    else
        echo -e -n "${YELLOW}$prompt [y/N]: ${NC}"
    fi

    read -r response
    response=${response:-$default}
    [[ "$response" =~ ^[Yy]$ ]]
}

# Print section header
section() {
    echo -e "\n${BLUE}━━━ $1 ━━━${NC}"
}

# Print status
status() {
    if is_installed "$2"; then
        echo -e "${GREEN}[INSTALLED]${NC} $1"
        return 0
    else
        echo -e "${RED}[MISSING]${NC} $1"
        return 1
    fi
}

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║       macOS Development Setup         ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# 1. Homebrew
section "Homebrew"
if status "Homebrew" "brew"; then :; else
    if ask "Install Homebrew?"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 2. CLI tools
section "CLI Tools"
MISSING_BREW=()
for pkg in git jq ripgrep fd fzf zsh neovim lazygit zellij starship; do
    brew list "$pkg" &> /dev/null || MISSING_BREW+=("$pkg")
done

if [[ ${#MISSING_BREW[@]} -eq 0 ]]; then
    echo -e "${GREEN}[INSTALLED]${NC} All CLI tools"
else
    echo -e "${RED}[MISSING]${NC} ${MISSING_BREW[*]}"
    if ask "Install missing CLI tools?"; then
        brew install "${MISSING_BREW[@]}"
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 3. Oh My Zsh
section "Oh My Zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo -e "${GREEN}[INSTALLED]${NC} Oh My Zsh"
else
    echo -e "${RED}[MISSING]${NC} Oh My Zsh"
    if ask "Install Oh My Zsh?"; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 4. Zsh plugins
section "Zsh Plugins"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    echo -e "${GREEN}[INSTALLED]${NC} zsh-autosuggestions, zsh-syntax-highlighting"
else
    echo -e "${RED}[MISSING]${NC} Zsh plugins"
    if ask "Install zsh-autosuggestions & zsh-syntax-highlighting?"; then
        [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] || \
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] || \
            git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 5. fnm + Node
section "Node.js (fnm)"
if status "fnm" "fnm"; then
    node --version 2>/dev/null && echo -e "${GREEN}[INSTALLED]${NC} Node $(node --version)"
else
    if ask "Install fnm + Node LTS?"; then
        brew install fnm
        eval "$(fnm env)"
        fnm install --lts
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 6. uv (Python)
section "Python (uv)"
if status "uv" "uv"; then :; else
    if ask "Install uv?"; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 7. .NET
section ".NET"
if is_installed "dotnet"; then
    echo -e "${GREEN}[INSTALLED]${NC}"
    dotnet --list-sdks
else
    echo -e "${RED}[MISSING]${NC} .NET"
    if ask "Install .NET 8, 9?"; then
        brew install dotnet@8
        brew install dotnet
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 8. Docker
section "Docker"
if status "Docker" "docker"; then :; else
    if ask "Install Docker Desktop?"; then
        brew install --cask docker
        echo -e "${GREEN}Done - Open Docker.app to complete setup${NC}"
    fi
fi

# 9. GitHub CLI
section "GitHub CLI"
if status "GitHub CLI" "gh"; then :; else
    if ask "Install GitHub CLI?"; then
        brew install gh
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Run 'gh auth login' to authenticate${NC}"
    fi
fi

# 10. Azure CLI
section "Azure CLI"
if status "Azure CLI" "az"; then :; else
    if ask "Install Azure CLI?"; then
        brew install azure-cli
        echo -e "${GREEN}Done${NC}"
        echo -e "${YELLOW}Run 'az login' to authenticate${NC}"
    fi
fi

# 11. Bun
section "Bun"
if status "Bun" "bun"; then :; else
    if ask "Install Bun?"; then
        curl -fsSL https://bun.sh/install | bash
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 12. Claude Code
section "Claude Code"
if status "Claude Code" "claude"; then :; else
    if ask "Install Claude Code?"; then
        npm install -g @anthropic-ai/claude-code
        echo -e "${GREEN}Done${NC}"
    fi
fi

# 13. openspec
section "openspec"
if npm list -g @fission-ai/openspec &> /dev/null; then
    echo -e "${GREEN}[INSTALLED]${NC} openspec"
else
    echo -e "${RED}[MISSING]${NC} openspec"
    if ask "Install openspec?"; then
        npm install -g @fission-ai/openspec
        echo -e "${GREEN}Done${NC}"
    fi
fi

# Done
echo -e "\n${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Setup Complete!            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo -e "\n${YELLOW}Remember to:${NC}"
echo "  1. Restart your terminal or run 'exec zsh'"
echo "  2. Run 'gh auth login' if you installed GitHub CLI"
echo "  3. Run 'az login' if you installed Azure CLI"
echo "  4. Install Claude plugins (inside Claude):"
echo "     /plugin install mindcontext-core@tmsjngx0"
echo "     /plugin install claude-mem@thedotmack"
echo "     /plugin install feature-dev@claude-plugins-official"
echo ""
