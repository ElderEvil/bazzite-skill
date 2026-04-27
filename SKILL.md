---
name: bazzite-skill
description: >
  Bazzite immutable OS desktop assistant with deep system context awareness.
  Use when editing ~/.config/ on Bazzite, managing rpm-ostree, flatpak,
  distrobox, ujust, gaming, NVIDIA, or KDE Plasma. Triggers: Bazzite,
  rpm-ostree, immutable, flatpak, distrobox, ujust, gaming, NVIDIA,
  container, layer, rebase.
---

# Bazzite Desktop Skill

Manage Bazzite (immutable Fedora) desktop systems — a gaming- and creator-focused Fedora Silverblue/Kinoite derivative with deep container integration.

This skill is for end-user customization on installed Bazzite systems. It is not for building Bazzite images or contributing to upstream projects.

## When This Skill MUST Be Used

**ALWAYS invoke this skill for end-user requests involving ANY of these:**

- Managing `rpm-ostree` (install, upgrade, rollback, rebase, layering, usroverlay)
- Installing or managing Flatpak applications
- Creating, entering, or managing Distrobox containers
- Running `ujust` recipes (update, setup-gaming, configure-desktop, etc.)
- Configuring NVIDIA drivers, GPU settings, or gaming optimizations
- Editing ANY file in `~/.config/` on a Bazzite system (KDE Plasma, MangoHud, etc.)
- Working with immutable OS concepts (read-only /usr, deployments, pinning)
- Setting up development environments on Bazzite
- Troubleshooting system-level issues on immutable Fedora
- Homebrew (brew) installation and management on Bazzite

**If you're about to modify system configuration on Bazzite, STOP and use this skill first.**

**Do NOT use this skill for Bazzite image building, bootc workflows, or upstream Fedora Silverblue development.**

## Critical Safety Rules

**For end-user customization tasks, NEVER modify anything under `/usr/`** — the entire `/usr` filesystem is read-only on Bazzite. Any attempt to write there will fail or require `rpm-ostree usroverlay` (ephemeral, lost on reboot).

```
/usr/                       # READ-ONLY - IMMUTABLE (NEVER EDIT)
├── bin/                    # System binaries (including bazzite-* helpers)
├── share/just/             # ujust recipes (read-only)
├── lib/                    # System libraries
└── etc/bazzite/            # Bazzite defaults (read-only)

~/.config/                  # WRITABLE - User configuration (safe to edit)
~/.local/share/             # WRITABLE - User data (Flatpak, Steam, etc.)
~/Games/                    # WRITABLE - Game installations
```

1. **Never** run `dnf` or `yum` directly on the Bazzite host — use inside Distrobox containers only.
2. **Always** run `rpm-ostree status` before making system changes to understand current deployment state.
3. **Prefer** Flatpak → Distrobox → Homebrew → rpm-ostree layering (in that order). Layering is LAST RESORT.
4. **Warn** about reboot requirements after any `rpm-ostree install` or `rpm-ostree uninstall` operation.
5. **Suggest** rollback procedure (`rpm-ostree rollback` + reboot) before any risky layering or rebasing.
6. **Never** suggest modifying `/usr` directly — it is immutable. Use `rpm-ostree usroverlay` only for temporary testing (lost on reboot).

## System Architecture

| Component | Purpose | Config Location |
|-----------|---------|-----------------|
| **Bazzite** | Fedora Silverblue/Kinoite-based immutable OS | `/etc/bazzite/` (read-only) |
| **KDE Plasma** | Desktop environment on Wayland | `~/.config/` (kdeglobals, plasmarc, etc.) |
| **rpm-ostree** | Immutable package manager (layers, images, deployments) | `/etc/rpm-ostreed.conf` |
| **Flatpak** | Primary desktop application format | `~/.local/share/flatpak/`, `~/.config/flatpak/` |
| **Distrobox** | Pet containers for development/CLI tools | `~/.config/distrobox/` |
| **NVIDIA drivers** | Proprietary GPU drivers via akmods | `/etc/modprobe.d/`, `nvidia-settings` |
| **Wayland session** | Display server protocol | `$WAYLAND_DISPLAY`, KDE Plasma settings |
| **ujust** | Bazzite recipe runner (`just` command wrapper) | `/usr/share/just/` (read-only) |
| **Homebrew** | CLI package manager (alternative to layering) | `~/.linuxbrew/`, `~/.config/homebrew/` |

## Command Discovery

```bash
# List all ujust recipes
ujust --list

# List all bazzite helper commands
compgen -c | grep -E '^bazzite-' | sort -u

# Check rpm-ostree deployment status
rpm-ostree status

# List installed Flatpak applications
flatpak list --app

# List Distrobox containers
distrobox list

# List Homebrew packages
brew list
```

### Command Categories

| Prefix | Purpose | Example |
|--------|---------|---------|
| `ujust` | Bazzite recipe runner | `ujust update`, `ujust setup-gaming` |
| `bazzite-*` | Bazzite helper scripts | `bazzite-toggle-user-mounts` |
| `rpm-ostree` | System package management | `rpm-ostree install`, `rpm-ostree upgrade` |
| `flatpak` | Desktop application management | `flatpak install flathub <app>` |
| `distrobox` | Container management | `distrobox create`, `distrobox enter` |
| `brew` | CLI tool installation | `brew install ripgrep` |

## Package Hierarchy

### The Bazzite Way to Install Software

Bazzite's immutable architecture requires a different mental model than traditional Linux. Follow this hierarchy **in order**:

1. **Flatpak** — Desktop applications (browsers, IDEs, games, media apps). Sandboxed, auto-updating, zero host pollution.
2. **Distrobox** — Development tools, language runtimes, CLI utilities that need a full package manager. Isolated, reproducible, exportable to host.
3. **Homebrew (brew)** — CLI tools that don't need a full container. Lightweight, user-space, no reboot needed.
4. **rpm-ostree layering** — System services, kernel modules, drivers. **LAST RESORT.** Requires reboot, increases image size, complicates updates.

| Scenario | Recommendation | Why |
|----------|---------------|-----|
| Desktop app (browser, IDE, media) | Flatpak | Sandboxed, auto-updates |
| CLI tool (ripgrep, jq, fzf) | Distrobox or Brew | No host pollution |
| System service (docker daemon, nginx) | Layer | Needs host integration |
| Kernel module | Layer | Must be in base image |
| Driver (NVIDIA, custom) | Layer | Requires system-level access |
| Development environment | Distrobox | Isolated dependencies |
| Game | Flatpak/Steam | Official support |
| Language runtime (Python, Node, Go) | Distrobox | Version isolation |

## Configuration Locations

| Path | Purpose | Safety |
|------|---------|--------|
| `/etc/bazzite/` | Bazzite system defaults | **Read-only** — do not modify |
| `/usr/share/just/` | ujust recipe definitions | **Read-only** — do not modify |
| `/usr/bin/bazzite-*` | Bazzite helper scripts | **Read-only** — do not modify |
| `~/.config/` | User configuration (KDE Plasma, MangoHud, etc.) | **Writable** — safe to edit |
| `~/.local/share/flatpak/` | Flatpak user installations | **Writable** — safe to manage |
| `~/.config/distrobox/` | Distrobox container configs | **Writable** — safe to edit |
| `~/.config/MangoHud/` | MangoHud gaming overlay config | **Writable** — safe to edit |
| `~/.local/share/Steam/steamapps/` | Steam game installations | **Writable** — safe to manage |
| `~/Games/` | Lutris/Heroic game installations | **Writable** — safe to manage |

## Safe Customization Patterns

### Pattern 1: Edit User Config Directly in ~/.config/ (KDE Plasma)

For simple changes, edit files in `~/.config/`:

```bash
# 1. Read current config
cat ~/.config/kdeglobals

# 2. Backup before changes
cp ~/.config/kdeglobals ~/.config/kdeglobals.bak.$(date +%s)

# 3. Make changes with Edit tool

# 4. Apply changes
# - KDE Plasma: most changes apply immediately or after relogin
# - MangoHud: restart the game/application
# - Flatpak apps: restart the app
```

### Pattern 2: Use Distrobox for Development Tools

```bash
# 1. Create a development container
distrobox create --name dev --image fedora:latest

# 2. Enter and install tools
distrobox enter dev
sudo dnf install -y git vim nodejs python3 golang rust cargo gcc make cmake

# 3. Export tools to host (optional)
distrobox-export --bin /usr/bin/node --export-path ~/.local/bin
distrobox-export --bin /usr/bin/python3 --export-path ~/.local/bin

# 4. Use exported tools directly from host
node --version
python3 --version
```

### Pattern 3: Use Flatpak for Desktop Applications

```bash
# 1. Search for an app
flatpak search vscode

# 2. Install from Flathub
flatpak install flathub com.visualstudio.code

# 3. Run the app
flatpak run com.visualstudio.code

# 4. Update all Flatpaks
flatpak update
```

### Pattern 4: Rollback with rpm-ostree rollback — ALWAYS ask user before rollback

```bash
# 1. Check current deployment state
rpm-ostree status

# 2. Explain to user what rollback will do:
#    "This will revert to the previous OS deployment. Any layered packages
#     installed after that deployment will be removed. A reboot is required."

# 3. ONLY after user confirmation:
rpm-ostree rollback

# 4. Reboot to apply
systemctl reboot
```

## Common Tasks

### System Detection

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

### System Update

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

### Installing Software

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

### Development Setup

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
podman run -d --name postgres-dev -e POSTGRES_PASSWORD=devpass -e POSTGRES_DB=devdb -p 5432:5432 postgres:16
podman run -d --name redis-dev -p 6379:6379 redis:7
```

**Export tools to host:**
```bash
distrobox-export --bin /usr/bin/node --export-path ~/.local/bin
distrobox-export --bin /usr/bin/python3 --export-path ~/.local/bin
distrobox-export --app code  # Export GUI app desktop entry
```

### Gaming Optimization

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

### NVIDIA Configuration

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

### Flatpak Management

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

### Homebrew Setup

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

## Troubleshooting

### rpm-ostree Issues

```bash
# Check deployment status
rpm-ostree status

# Rebase to a different image stream or version
rpm-ostree rebase <ref>
# Example: rpm-ostree rebase bazzite:stable/bazzite-nvidia

# See what changed between deployments
rpm-ostree db diff

# Clean up old deployments
rpm-ostree cleanup -p    # Remove pending
rpm-ostree cleanup -r    # Remove rollback
rpm-ostree cleanup -m    # Remove all unused

# Refresh metadata (if "Packages not found")
rpm-ostree refresh-md

# Search for correct package name
rpm-ostree search <package>

# Cancel stuck transaction
rpm-ostree cancel

# Pin current deployment (prevents cleanup)
ostree admin pin 0

# Unpin when no longer needed
ostree admin unpin 0

# Override a base package (replace system package with different version)
rpm-ostree override replace <package-url-or-path>
rpm-ostree override remove <package>    # Remove a base package
rpm-ostree override reset <package>     # Reset override to base version
rpm-ostree override reset --all         # Reset all overrides
```

### Flatpak Issues

```bash
# Repair corrupted installations
flatpak repair

# List all installed apps
flatpak list --app

# Remove an app and its data
flatpak uninstall --delete-data <app-id>

# Check for runtime issues
flatpak info <app-id>
```

### Distrobox Issues

```bash
# Stop a container
distrobox stop <name>

# Remove a container
distrobox rm <name>

# Recreate from scratch
distrobox stop <name>
distrobox rm <name>
distrobox create --name <name> --image <image>

# Fix display issues inside container
distrobox enter <name> -- echo $DISPLAY
# Should show :0 or wayland-0
```

### NVIDIA Issues

```bash
# Check GPU status
nvidia-smi

# Check Vulkan support
vulkaninfo | head -n 20

# Open NVIDIA settings
nvidia-settings

# Check if NVIDIA DRM modeset is enabled
cat /sys/module/nvidia_drm/parameters/modeset
```

### Wayland Issues

```bash
# Check if running on Wayland
echo $WAYLAND_DISPLAY
echo $XDG_SESSION_TYPE

# Force Electron apps to use Wayland
electron --ozone-platform-hint=auto

# Force X11 fallback if needed
# (set in KDE System Settings > Display and Monitor)
```

### Rollback Procedure

```bash
# 1. Check current state
rpm-ostree status

# 2. Rollback to previous deployment
rpm-ostree rollback

# 3. Reboot to apply
systemctl reboot

# 4. Verify after reboot
rpm-ostree status
```

### Deployment Cleanup

```bash
# Remove pending deployment (frees space)
rpm-ostree cleanup -p

# Remove rollback deployment (frees space)
rpm-ostree cleanup -r

# Remove ALL unused deployments (nuclear option)
rpm-ostree cleanup -m
```

## Decision Framework

When user requests system changes, follow this flow:

1. **Is it a desktop app?** → Flatpak (`flatpak install flathub <app>`)
2. **Is it a CLI tool?** → Distrobox or Brew (`brew install <tool>` or `distrobox create`)
3. **Is it a system service or driver?** → rpm-ostree layer (**warn about reboot**)
4. **Is it gaming-related?** → `ujust setup-gaming` + NVIDIA tweaks
5. **Is it a KDE Plasma config?** → Edit `~/.config/` directly
6. **Not sure?** → Check `ujust --list` first, then `rpm-ostree status`

## Out of Scope

This skill intentionally does not cover:

- **Bazzite image building** — Creating custom Bazzite ISOs or OCI images
- **ujust recipe development** — Writing new `/usr/share/just/` recipes
- **bootc** — Bootable container workflows (too early, Bazzite still uses rpm-ostree)
- **Modifying `/usr` on host** — The filesystem is immutable; this is by design
- **Container runtime management** — Podman/Docker daemon configuration (use Distrobox instead)

## Example Requests

**User**: "Install Docker"

**Agent**: On your Bazzite system, you have several options:

1. **Recommended (Podman)**: Bazzite includes Podman natively — Docker-compatible, no setup needed.
   ```bash
   podman --version
   podman run hello-world
   ```

2. **Alternative (Distrobox)**: Run Docker inside a container.
   ```bash
   distrobox create --name docker-host --image fedora:latest
   distrobox enter docker-host
   sudo dnf install docker
   sudo systemctl start docker
   ```

3. **Last Resort (Layering)**: Only if you truly need a host Docker daemon.
   ```bash
   rpm-ostree install docker-ce docker-ce-cli containerd.io
   # Requires reboot
   ```
   ⚠️ This increases image size and update time.

I'd recommend Podman for most use cases. Want me to help set it up?

---

**User**: "Update my system"

**Agent**: On your Bazzite system, updates work differently than traditional distros:

```bash
# Update the OS image
ujust update
# Or manually:
rpm-ostree upgrade

# Update Flatpaks
flatpak update -y

# Check if reboot needed
rpm-ostree status
```

⚠️ If `rpm-ostree upgrade` staged a new deployment, you'll need to reboot to use it. Want me to run these commands?

---

**User**: "Optimize for gaming"

**Agent**: With your NVIDIA GPU on Bazzite, let's optimize gaming performance:

```bash
# Run Bazzite's gaming setup
ujust setup-gaming

# Verify NVIDIA driver
nvidia-smi

# Configure MangoHud overlay
mkdir -p ~/.config/MangoHud
# (creates MangoHud.conf with fps, frametime, cpu/gpu stats)
```

This configures GameMode, MangoHud, Proton-GE, and Steam. Want me to run the gaming setup?

---

**User**: "Install ripgrep"

**Agent**: For `ripgrep` on Bazzite:

```bash
# Check if already installed (Bazzite includes many tools)
which rg || rg --version

# If not found, use Homebrew (preferred for CLI tools)
brew install ripgrep

# Or try a temporary overlay to test first
rpm-ostree usroverlay
sudo dnf install ripgrep
# (lost on reboot — use this to test before committing)
```

Want me to check if it's already installed?

---

**User**: "Set up Python development"

**Agent**: On your Bazzite system, I'll set up Python development using Distrobox to keep the host clean:

```bash
# Create Python development container
distrobox create --name python-dev --image fedora:latest --home ~/containers/python-dev

# Enter and install tools
distrobox enter python-dev
sudo dnf install -y python3 python3-pip python3-virtualenv python3-devel gcc git

# Optional: export Python to host
distrobox-export --bin /usr/bin/python3 --export-path ~/.local/bin
```

Your `~/projects/` directory is accessible from both host and container. Want me to create this container?
