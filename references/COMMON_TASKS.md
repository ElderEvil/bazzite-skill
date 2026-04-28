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
cat /sys/class/drm/card*/device/vendor 2>/dev/null | head -n 1
# 0x10de = NVIDIA, 0x1002 = AMD, 0x8086 = Intel

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

# Or via Distrobox
distrobox create --name cli-tools --image fedora:latest
distrobox enter cli-tools
sudo dnf install -y ripgrep jq fzf bat eza
distrobox-export --bin /usr/bin/rg --export-path ~/.local/bin
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

**Python development:**
```bash
distrobox create --name python-dev --image fedora:latest --home ~/containers/python-dev
distrobox enter python-dev
sudo dnf install -y python3 python3-pip python3-virtualenv python3-devel gcc gcc-c++ make git
# Install pyenv for version management
curl https://pyenv.run | bash
```

**Full-stack (Node.js + databases):**
```bash
# Node.js container
distrobox create --name node-dev --image node:20
distrobox enter node-dev
npm install -g typescript ts-node nodemon

# Database via Podman (more standard for services)
# Use environment variables or a .env file for secrets; never hardcode passwords.
podman run -d --name postgres-dev -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" -e POSTGRES_DB="${POSTGRES_DB}" -e POSTGRES_USER="${POSTGRES_USER:-postgres}" -p 5432:5432 postgres:16
podman run -d --name redis-dev -e REDIS_PASSWORD="${REDIS_PASSWORD}" -p 6379:6379 redis:7
```

**Export tools to host:**
```bash
distrobox-export --bin /usr/bin/node --export-path ~/.local/bin
distrobox-export --bin /usr/bin/python3 --export-path ~/.local/bin
distrobox-export --app code  # Export GUI app desktop entry
```

## Gaming Optimization

```bash
# Step 1: Run Bazzite gaming setup
ujust setup-gaming
# Configures: GameMode, MangoHud, Proton-GE, Steam, Lutris

# Step 2: NVIDIA-specific optimizations
nvidia-smi
sudo nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'
cat /proc/driver/nvidia/gpus/*/information

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
nvidia-smi -q -d PERFORMANCE
ls ~/.local/share/Steam/compatibilitytools.d/
```

## NVIDIA Configuration

```bash
# Check driver status
nvidia-smi

# Check Vulkan compatibility
vulkaninfo | head -n 20

# NVIDIA settings GUI
nvidia-settings

# Verify DRM modeset (should be enabled on Bazzite)
cat /sys/module/nvidia_drm/parameters/modeset
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
