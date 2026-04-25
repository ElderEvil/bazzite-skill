# Distrobox Patterns for Bazzite

## What is Distrobox?

Distrobox creates "pet containers" — containers that feel like native applications. They integrate with your host desktop, can run GUI apps, and share your home directory.

## Why Distrobox on Bazzite?

Bazzite is immutable, meaning the base system is read-only. Distrobox lets you:
- Install any package without layering
- Have multiple isolated environments
- Run different distros side-by-side
- Keep your host system pristine

## Basic Commands

### Create a Container

```bash
# Basic Fedora container
distrobox create --name fedora-dev --image fedora:latest

# Ubuntu container
distrobox create --name ubuntu-dev --image ubuntu:24.04

# Arch container (for AUR access)
distrobox create --name arch-dev --image archlinux:latest

# With custom home directory
distrobox create --name work --image fedora:latest --home ~/containers/work
```

### Enter a Container

```bash
# Enter interactive shell
distrobox enter fedora-dev

# Run single command
distrobox enter fedora-dev -- python3 --version

# Use short alias (after first enter)
# Just type: fedora-dev
```

### Manage Containers

```bash
# List containers
distrobox list

# Stop container
distrobox stop fedora-dev

# Remove container
distrobox rm fedora-dev

# Export app to host
distrobox-export --app firefox

# Export binary to host
distrobox-export --bin /usr/bin/htop --export-path ~/.local/bin
```

## Common Patterns

### Pattern 1: Development Environment

```bash
# Create
distrobox create --name dev --image fedora:latest

# Enter and setup
distrobox enter dev
sudo dnf install -y \
  git \
  vim \
  nodejs \
  python3 \
  python3-pip \
  golang \
  rust cargo \
  gcc gcc-c++ \
  make cmake

# Export common tools
distrobox-export --bin /usr/bin/go
distrobox-export --bin /usr/bin/python3
distrobox-export --bin /usr/bin/node
```

### Pattern 2: Language-Specific Container

```bash
# Python data science
distrobox create --name datascience --image python:3.12
distrobox enter datascience
pip install jupyter pandas numpy matplotlib scikit-learn

# Export Jupyter
distrobox-export --app jupyter-notebook
```

### Pattern 3: GUI Applications

```bash
# Container with GUI apps
distrobox create --name gui-apps --image fedora:latest
distrobox enter gui-apps
sudo dnf install gimp inkscape kdenlive

# Export to host
distrobox-export --app gimp
distrobox-export --app inkscape
```

### Pattern 4: Legacy/Compatibility

```bash
# Old Ubuntu for legacy tools
distrobox create --name legacy --image ubuntu:20.04
distrobox enter legacy
# Install old versions of tools
```

### Pattern 5: Clean Build Environment

```bash
# Fresh environment for each project
distrobox create --name project-build --image fedora:latest
distrobox enter project-build
# Install build deps
# Build project
# Copy artifacts to host
```

## Integration with IDEs

### VS Code (Flatpak)

1. Install VS Code via Flatpak
2. Install "Dev Containers" extension
3. Configure to use Distrobox:

```json
// .vscode/settings.json
{
  "dev.containers.dockerPath": "podman",
  "dev.containers.executeInWSL": false
}
```

### Neovim

Use from within the container:

```bash
distrobox enter dev
nvim ~/projects/my-project
```

Or configure host Neovim to use container tools:

```lua
-- In init.lua
vim.g.python3_host_prog = '/usr/bin/distrobox-enter -n dev -- python3'
```

## Advanced Tips

### Pre-init Hooks

Run commands before entering:

```bash
# ~/.config/distrobox/distrobox.conf
distrobox_pre_init_hook="echo 'Welcome to dev container!'"
```

### Custom Images

Create a Dockerfile for your perfect dev environment:

```dockerfile
# Dockerfile.dev
FROM fedora:latest
RUN dnf install -y \
    git vim tmux \
    nodejs golang \
    && dnf clean all
COPY my-dotfiles /tmp/dotfiles
RUN /tmp/dotfiles/install.sh
```

```bash
# Build and use
distrobox create --name my-dev --image ./Dockerfile.dev
```

### GPU Access

Containers can use host GPU:

```bash
# NVIDIA
distrobox create --name cuda --image nvidia/cuda:12.0-devel-fedora38

# AMD/Intel (usually works by default)
distrobox create --name gpu --name fedora:latest
```

### systemd Services in Containers

```bash
distrobox create --name service-box --image fedora:latest --init
distrobox enter service-box
sudo systemctl enable --now my-service
```

## Comparison: Distrobox vs. Toolbox vs. Podman

| Feature | Distrobox | Toolbox | Podman |
|---------|-----------|---------|--------|
| Host integration | Excellent | Good | Manual |
| GUI apps | Native feel | Native feel | Needs config |
| Multiple distros | Yes | Fedora only | Any |
| Export apps | Yes | Limited | Manual |
| Ease of use | Very easy | Easy | Complex |
| **Bazzite choice** | **Recommended** | Good | Advanced |

## Troubleshooting

### "Cannot connect to display"

```bash
# Ensure X11/Wayland socket is shared
distrobox enter my-box -- echo $DISPLAY
# Should show :0 or wayland-0
```

### "Permission denied"

```bash
# Rebuild with proper permissions
distrobox stop my-box
distrobox rm my-box
distrobox create --name my-box --image fedora:latest
```

### Slow startup

```bash
# Keep container running
distrobox enter my-box
# Leave shell open, or use:
distrobox enter my-box -- sudo systemctl enable --now systemd-userdbd
```

## Best Practices

1. **One purpose per container**: Don't install everything in one box
2. **Export frequently used tools**: `distrobox-export --bin`
3. **Use versioned images**: `fedora:40` instead of `fedora:latest`
4. **Clean up unused**: `distrobox rm old-box`
5. **Backup important containers**: Export package lists

## Quick Reference Card

```bash
# Create
distrobox create -n <name> -i <image>

# Enter
distrobox enter <name>

# Export app
distrobox-export --app <app>

# Export binary
distrobox-export --bin <path> --export-path ~/.local/bin

# List
distrobox list

# Remove
distrobox rm <name>

# Stop
distrobox stop <name>
```
