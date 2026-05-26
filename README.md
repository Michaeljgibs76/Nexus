# Nexus
News App

## Mac Terminal Setup

To configure Git and GitHub SSH access on a Mac, run the included setup script:

```bash
chmod +x setup-github-mac.sh
./setup-github-mac.sh
```

The script will:
1. Verify Git is installed (via Xcode Command Line Tools)
2. Configure your Git name and email
3. Generate an Ed25519 SSH key and add it to the macOS keychain
4. Copy your public key to the clipboard for easy addition at github.com/settings/keys
5. Test the GitHub SSH connection
6. Optionally clone this repository

### Manual Quick-Start

```bash
# Install Xcode Command Line Tools (includes git)
xcode-select --install

# Configure identity
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Generate SSH key
ssh-keygen -t ed25519 -C "you@example.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Print key to copy into github.com/settings/keys
cat ~/.ssh/id_ed25519.pub

# Clone this repo
git clone git@github.com:michaeljgibs76/nexus.git
```
