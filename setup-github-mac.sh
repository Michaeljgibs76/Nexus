#!/bin/bash
# GitHub Mac Terminal Setup for Nexus

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== GitHub Mac Terminal Setup ===${NC}"
echo ""

# 1. Check for Xcode Command Line Tools (includes git)
echo "Checking for Git..."
if ! command -v git &>/dev/null; then
    echo -e "${YELLOW}Git not found. Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo "Re-run this script after the installation completes."
    exit 1
else
    echo -e "${GREEN}Git found: $(git --version)${NC}"
fi

# 2. Configure Git identity
echo ""
echo "Configuring Git identity..."

CURRENT_NAME=$(git config --global user.name 2>/dev/null || true)
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || true)

if [ -z "$CURRENT_NAME" ]; then
    read -p "Enter your full name for Git commits: " GIT_NAME
    git config --global user.name "$GIT_NAME"
else
    echo "  Name already set: $CURRENT_NAME"
fi

if [ -z "$CURRENT_EMAIL" ]; then
    read -p "Enter your GitHub email address: " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
else
    echo "  Email already set: $CURRENT_EMAIL"
fi

git config --global core.editor "nano"
git config --global init.defaultBranch main

echo -e "${GREEN}Git identity configured.${NC}"

# 3. SSH key setup
echo ""
echo "Checking for SSH key..."

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$SSH_KEY" ]; then
    CONFIGURED_EMAIL=$(git config --global user.email)
    echo -e "${YELLOW}No SSH key found. Generating one...${NC}"
    ssh-keygen -t ed25519 -C "$CONFIGURED_EMAIL" -f "$SSH_KEY" -N ""
    echo -e "${GREEN}SSH key generated.${NC}"
else
    echo -e "${GREEN}SSH key already exists at $SSH_KEY${NC}"
fi

# Start ssh-agent and add key
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add "$SSH_KEY" 2>/dev/null

# 4. Add SSH key to macOS keychain (so you don't re-enter passphrase)
if [[ "$(uname)" == "Darwin" ]]; then
    ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || true
    # Ensure SSH config uses keychain
    SSH_CONFIG="$HOME/.ssh/config"
    if ! grep -q "UseKeychain" "$SSH_CONFIG" 2>/dev/null; then
        mkdir -p "$HOME/.ssh"
        cat >> "$SSH_CONFIG" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $SSH_KEY
EOF
        chmod 600 "$SSH_CONFIG"
        echo "SSH config updated for GitHub."
    fi
fi

# 5. Display public key for GitHub
echo ""
echo -e "${YELLOW}=== Add this SSH key to GitHub ===${NC}"
echo ""
cat "${SSH_KEY}.pub"
echo ""
echo "Steps to add this key to GitHub:"
echo "  1. Copy the key above"
echo "  2. Go to: https://github.com/settings/ssh/new"
echo "  3. Title: give it a name (e.g. 'My Mac')"
echo "  4. Key type: Authentication Key"
echo "  5. Paste the key and click 'Add SSH key'"
echo ""

# Copy to clipboard if on macOS
if command -v pbcopy &>/dev/null; then
    cat "${SSH_KEY}.pub" | pbcopy
    echo -e "${GREEN}Public key copied to clipboard!${NC}"
fi

# 6. Test GitHub connection
echo ""
echo "Testing GitHub SSH connection (after you've added the key)..."
read -p "Press Enter to test the connection (or Ctrl+C to skip)..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${GREEN}GitHub SSH connection successful!${NC}"
else
    echo -e "${YELLOW}Connection test returned a message above — if it says 'successfully authenticated' you're good to go.${NC}"
fi

# 7. Clone the Nexus repo (if not already inside it)
echo ""
REPO_URL="git@github.com:michaeljgibs76/nexus.git"
if git -C . rev-parse 2>/dev/null; then
    echo -e "${GREEN}Already inside a Git repository.${NC}"
    echo "Remote origin: $(git remote get-url origin 2>/dev/null || echo 'none')"
else
    read -p "Clone the Nexus repo to the current directory? [y/N] " CLONE_CONFIRM
    if [[ "$CLONE_CONFIRM" =~ ^[Yy]$ ]]; then
        git clone "$REPO_URL"
        echo -e "${GREEN}Repository cloned.${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=== Setup complete! ===${NC}"
echo ""
echo "Useful Git commands:"
echo "  git status          — show working tree status"
echo "  git pull            — fetch and merge latest changes"
echo "  git add <file>      — stage a file"
echo "  git commit -m '...' — commit staged changes"
echo "  git push            — push commits to GitHub"
echo "  git log --oneline   — view commit history"
echo ""
