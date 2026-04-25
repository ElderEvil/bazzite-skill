# rpm-ostree Guide for Bazzite Users

## What is rpm-ostree?

`rpm-ostree` is the package manager for immutable Fedora systems like Bazzite. Unlike traditional `dnf` or `apt`, it works with **layers** and **images** rather than direct package installation.

Think of it like Git for your operating system:
- Each change creates a new "commit" (deployment)
- You can rollback to previous versions
- The base system is read-only (immutable)

## Core Commands

### Check Status

```bash
rpm-ostree status
```

Shows:
- Current deployment (booted)
- Pending deployment (if update downloaded)
- Rollback deployment (previous version)

### Update System

```bash
# Check for updates
rpm-ostree upgrade --check

# Download and stage update
rpm-ostree upgrade

# After update, reboot to apply
systemctl reboot
```

### Install Packages (Layering)

```bash
# Install a package
rpm-ostree install htop

# Install multiple packages
rpm-ostree install htop neofetch btop

# Reboot required to use layered packages
systemctl reboot
```

⚠️ **Warning**: Layered packages increase update size and complexity. Prefer flatpak or distrobox when possible.

### Remove Layered Packages

```bash
rpm-ostree uninstall htop

# Reboot to apply
systemctl reboot
```

### Temporary Changes

```bash
# Apply temporary overlay (lost on reboot)
rpm-ostree usroverlay

# Now you can use dnf temporarily
sudo dnf install some-package

# Check if overlay is active
rpm-ostree status
```

### Rollback

```bash
# Rollback to previous deployment
rpm-ostree rollback

# Reboot to apply
systemctl reboot
```

### Rebase (Switch Images)

```bash
# Switch to different Bazzite variant
rpm-ostree rebase bazzite:stable/bazzite-nvidia

# Rebase to testing
rpm-ostree rebase bazzite:testing

# Rebase to specific version
rpm-ostree rebase bazzite:stable/41
```

## Understanding Deployments

```
State: idle
Deployments:
* fedora:fedora/41/x86_64/silverblue
             Version: 41.20241020.0 (2024-10-20T01:23:45Z)
          BaseCommit: abcdef123456...
              Commit: abcdef123456...
            Packages: htop, neofetch  <-- Layered packages
                    LayeredPackages: htop neofetch

  fedora:fedora/41/x86_64/silverblue
             Version: 41.20241020.0 (2024-10-20T01:23:45Z)
          BaseCommit: abcdef123456...
```

The `*` marks the currently booted deployment.

## Best Practices

### 1. Minimize Layering

Before layering, ask:
- Is it available as Flatpak? → Use Flatpak
- Can it run in Distrobox? → Use Distrobox
- Is it a system-level tool? → Consider layering

### 2. Layer in Batches

Instead of layering one package at a time:

```bash
# Good: Layer related tools together
rpm-ostree install gcc make gdb valgrind

# Avoid: Layering one by one (creates many deployments)
```

### 3. Reboot Promptly

After installing layered packages, reboot soon:

```bash
rpm-ostree install some-package && systemctl reboot
```

### 4. Clean Up Old Deployments

```bash
# Remove pending deployment
rpm-ostree cleanup -p

# Remove rollback deployment
rpm-ostree cleanup -r

# Remove all unused deployments
rpm-ostree cleanup -m
```

### 5. Pin Important Deployments

```bash
# Pin current deployment (prevents cleanup)
ostree admin pin 0

# Unpin when no longer needed
ostree admin unpin 0
```

## Common Patterns

### Pattern: Try Before You Buy

```bash
# Test package with temporary overlay
rpm-ostree usroverlay
sudo dnf install some-package

# Test it...
# If you like it, layer properly:
# rpm-ostree install some-package

# Reboot to clear overlay
systemctl reboot
```

### Pattern: Safe Update

```bash
# 1. Check what's new
rpm-ostree upgrade --check

# 2. Read changelog (if available)
rpm-ostree db diff

# 3. Apply update
rpm-ostree upgrade

# 4. Test before committing
# Reboot, test everything
# If broken: rpm-ostree rollback
```

### Pattern: Development Tools

Instead of layering dev tools:

```bash
# Create dev container
distrobox create --name dev --image fedora:latest

# Install everything inside
distrobox enter dev
sudo dnf install nodejs python golang

# Export tools to host
distrobox-export --bin /usr/bin/node
```

## Troubleshooting

### "error: Packages not found"

```bash
# Refresh metadata
rpm-ostree refresh-md

# Search for correct name
rpm-ostree search htop
```

### "error: Transaction in progress"

```bash
# Cancel pending transaction
rpm-ostree cancel

# Check status
rpm-ostree status
```

### Update Too Large

```bash
# Check what's making it large
rpm-ostree db diff

# Remove unnecessary layered packages
rpm-ostree uninstall package1 package2

# Clean up
rpm-ostree cleanup -p
```

## When to Layer vs. Other Options

| Scenario | Recommendation | Why |
|----------|---------------|-----|
| Desktop app | Flatpak | Sandboxed, auto-updates |
| CLI tool | Distrobox/Brew | No host pollution |
| System service | Layer | Needs host integration |
| Kernel module | Layer | Must be in base image |
| Driver | Layer | Requires system-level access |
| Development env | Distrobox | Isolated dependencies |
| Browser | Flatpak | Security, isolation |
| Game | Flatpak/Steam | Official support |
