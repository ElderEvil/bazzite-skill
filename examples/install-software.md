# Example: Installing Software on Bazzite

## Scenario: User wants to install VS Code

### User Prompt
"Install VS Code on my system"

### Skill-Enhanced Response

On your Bazzite system, you have several options for VS Code, depending on your workflow:

#### Option 1: Flatpak (Recommended for most users)

```bash
flatpak install flathub com.visualstudio.code
```

✅ **Pros:** Sandboxed, auto-updates, no host pollution  
❌ **Cons:** Slightly isolated from host tools

**Best for:** General development, web development

---

#### Option 2: Distrobox (Recommended for system-level development)

```bash
# Create a development container
distrobox create --name dev --image fedora:latest

# Enter container
distrobox enter dev

# Install VS Code inside container
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code

# Export to host (creates .desktop entry)
distrobox-export --app code
```

✅ **Pros:** Full host integration, access to host files, isolated dependencies  
❌ **Cons:** Requires container setup

**Best for:** Python, Go, Rust, C++ development

---

#### Option 3: Layer with rpm-ostree (Use sparingly)

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
rpm-ostree install code
```

⚠️ **Warning:** This layers the package into your base image. Requires reboot.

✅ **Pros:** Native performance, no container overhead  
❌ **Cons:** Increases image size, slower updates, harder to remove

**Best for:** When Flatpak/Distrobox absolutely don't work

---

### Recommendation

For your system with 64GB RAM, I'd recommend **Option 2 (Distrobox)**. You can create a dedicated development container with all your tools, and it'll integrate seamlessly with KDE Plasma.

Want me to set up the Distrobox development environment for you?

---

## Scenario: User wants to install a CLI tool (e.g., ripgrep)

### User Prompt
"Install ripgrep"

### Skill-Enhanced Response

For `ripgrep` on Bazzite, I have good news — it's likely already available, or we can get it easily:

```bash
# Check if already installed (Bazzite includes many tools)
which rg

# If not found, use a temporary overlay (doesn't persist)
rpm-ostree usroverlay
sudo dnf install ripgrep

# Or install via Brew (if you use Homebrew)
brew install ripgrep
```

**Note:** `ripgrep` is commonly included in Bazzite's base image. Let me check your system first:

```bash
rg --version || echo "Not installed"
```

If it's not there, I'd suggest using **Brew** (Homebrew) since it works well on Bazzite without layering:

```bash
# Install brew if not already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ripgrep
brew install ripgrep
```

Want me to check if it's already installed?
