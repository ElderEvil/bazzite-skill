# Common Tasks

## System Detection

To understand the current Bazzite system profile, run these commands:

```bash
# Basic system info
hostname
uname -r                          # Kernel version
uname -m                          # Architecture (x86_64, aarch64)

# CPU and RAM
grep 'model name' /proc/cpuinfo | head -n 1 | cut -d':' -f2 | xargs
nproc                             # CPU cores
free -h | awk '/^Mem:/ {print $2}'

# GPU detection
lspci | grep -i vga | cut -d':' -f3 | xargs

# Desktop session
echo $XDG_CURRENT_DESKTOP          # KDE, GNOME, etc.
echo $XDG_SESSION_TYPE             # wayland, x11

# Bazzite-specific
cat /etc/bazzite/image_name 2>/dev/null || echo "not bazzite"
cat /etc/bazzite/version 2>/dev/null || echo "unknown"
```

## System Update

```bash
# Preferred: use ujust
ujust update

# Or manually:
# 1. Check for updates
rpm-ostree upgrade --check

# 2. Download and stage update
rpm-ostree upgrade

# 3. Update Flatpaks
flatpak update -y

# 4. Check if reboot needed
rpm-ostree status
# If a new deployment was staged, reboot to apply:
# systemctl reboot
```

## Installing Software

**Desktop applications — use Flatpak:**
```bash
flatpak install flathub com.visualstudio.code
flatpak install flathub org.mozilla.firefox
flatpak install flathub com.spotify.Client
```

**CLI tools — use Homebrew (preferred) or Distrobox:**
```bash
# Homebrew (if installed)
brew install ripgrep jq fzf bat eza

# Or via Distrobox (dnf only works inside containers)
distrobox create --name cli-tools --image fedora:latest
distrobox enter cli-tools
sudo dnf install -y ripgrep jq fzf bat eza
distrobox-export --bin /usr/bin/rg --export-path ~/.local/bin
```

**Python tools — use uv (fastest) or Distrobox:**
```bash
# Install uv via script (works from any terminal)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Use uv inside Distrobox for versioning
distrobox create --name python-dev --image fedora:latest
distrobox enter python-dev
# Inside container: install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create venv and install packages
uv venv
uv pip install pandas numpy scipy
```

**Node.js tools — use pnpm (recommended):**
```bash
# Install via Homebrew (includes node + pnpm together)
brew install node

# pnpm is included with node, or install separately:
brew install pnpm
```

**System services/drivers — use rpm-ostree layering (LAST RESORT):**
```bash
# Check status first
rpm-ostree status

# Layer packages (requires reboot)
rpm-ostree install docker-ce docker-ce-cli containerd.io

# Reboot to apply
systemctl reboot
```

## Development Setup

**Python development (use uv - recommended):**
```bash
# Install uv via script
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create venv and sync from pyproject.toml
uv sync
# Or: uv venv && uv pip install -r requirements.txt (legacy)
```

**Node.js development (use pnpm - recommended):**
```bash
# Install via Homebrew (includes node + pnpm together)
brew install node

# Create project with pnpm
pnpm install
pnpm add <package>
```

## Gaming Optimization

```bash
# Step 1: Run Bazzite gaming setup
ujust setup-gaming
# Configures: GameMode, MangoHud, Proton-GE, Steam, Lutris

# Step 2: GPU-specific optimizations
# For NVIDIA:
nvidia-smi
sudo nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'

# For AMD:
# Most gaming optimizations are handled automatically by the AMD driver

# Step 3: MangoHud configuration
mkdir -p ~/.config/MangoHud
cat > ~/.config/MangoHud/MangoHud.conf << 'EOF'
fps
frametime
cpu_stats
gpu_stats
ram
vram
position=top-left
background_alpha=0.5
font_size=18
text_color=FFFFFF
EOF

# Step 4: Steam launch options
# gamemoderun mangohud %command%

# Step 5: Verify
gamemoded -s
mangohud vkcube
```

## GPU Configuration

```bash
# For NVIDIA: check driver status
nvidia-smi

# Check Vulkan compatibility
vulkaninfo | head -n 20

# GPU settings GUI (NVIDIA or generic)
# nvidia-settings
# kde-system-settings (for KDE Plasma)
```

## Flatpak Management

```bash
# List installed apps
flatpak list --app

# Search for apps
flatpak search <name>

# Install
flatpak install flathub <app-id>

# Update all
flatpak update

# Remove
flatpak uninstall <app-id>

# Repair (if corrupted)
flatpak repair
```

## Homebrew Setup

```bash
# Install Homebrew (if not present)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (follow installer instructions)
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install CLI tools
brew install ripgrep jq fzf bat eza zoxide

# List installed
brew list
```

## uv Setup (Python Package Manager)

```bash
# Install via script (your preferred method)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Sync from pyproject.toml (recommended)
uv sync

# Or create venv manually
uv venv
uv pip install <package>
uv pip install -r requirements.txt  # legacy
```

## pnpm Setup (Node Package Manager)

```bash
# Install via Homebrew (includes node + pnpm together)
brew install node

# Or pnpm alone:
brew install pnpm
```
