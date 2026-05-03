# Troubleshooting

## rpm-ostree Issues

```bash
# Check deployment status
rpm-ostree status

# Rebase to a different image stream or version
# Pre-flight: capture current state and ensure you can recover
rpm-ostree status
# Verify no outstanding overrides that could conflict
rpm-ostree override list
# Prepare rollback path: if the rebase fails or breaks something,
# you can return to the previous deployment with:
#   rpm-ostree rollback && systemctl reboot
# Ensure critical data is backed up before rebasing.
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

## Flatpak Issues

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

## Distrobox Issues

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

## GPU Issues

```bash
# Check GPU status (NVIDIA)
nvidia-smi

# Check Vulkan support
vulkaninfo | head -n 20

# GPU settings (NVIDIA)
# nvidia-settings
```

## Wayland Issues

```bash
# Check if running on Wayland
echo $WAYLAND_DISPLAY
echo $XDG_SESSION_TYPE

# Force Electron apps to use Wayland
electron --ozone-platform-hint=auto

# Force X11 fallback if needed
# (set in KDE System Settings > Display and Monitor)
```

## Rollback Procedure

```bash
# 1. Check current state
rpm-ostree status

# 2. Confirm rollback with the user
# Explain impact: "This will revert to the previous OS deployment.
# Any layered packages installed after that deployment will be removed.
# A reboot is required."
# Prompt: "Type 'yes' to proceed with rollback:"
# Only continue if the user explicitly confirms.

# 3. Rollback to previous deployment (only after confirmation)
rpm-ostree rollback

# 4. Reboot to apply
systemctl reboot

# 5. Verify after reboot
rpm-ostree status
```

## Deployment Cleanup

```bash
# Remove pending deployment (frees space)
rpm-ostree cleanup -p

# Remove rollback deployment (frees space)
rpm-ostree cleanup -r

# Remove ALL unused deployments (nuclear option)
rpm-ostree cleanup -m
```
