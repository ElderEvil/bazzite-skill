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
# Check GPU status
nvidia-smi

# Check Vulkan support
vulkaninfo | head -n 20

# GPU settings (NVIDIA)
# nvidia-settings

# GPU settings (AMD)
# radeontop or LACT

# Check if NVIDIA DRM modeset is enabled
cat /sys/module/nvidia_drm/parameters/modeset
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
# Remove ALL unused deployments (nuclear option)
rpm-ostree cleanup -m
```

## Audio / PipeWire Issues

### Low volume despite 100% in system tray

USB audio devices (headsets, speakers) have **two independent volume controls in series**:

| Layer | What controls it | Where to check |
|-------|-----------------|----------------|
| **PipeWire software volume** | KDE volume slider, `pactl`, `wpctl` | System tray — shows what you expect |
| **ALSA hardware mixer** | Physical volume wheel/knob on the device, or `amixer` | Hidden — often gets knocked down without the OS noticing |

The physical controls on USB devices (headset wheel, speaker knob) map directly to the ALSA hardware mixer, **not** the PipeWire volume. So the OS can show 100% while the hardware is actually capped much lower.

**Diagnose it:**

```bash
# Find your audio card index
pactl list sinks short

# Check ALSA hardware PCM volume (replace N with card number)
amixer -c N sget PCM

# Example output for a headset at reduced volume:
#   Front Left: Playback 51 [69%] [-23.00dB]  ← capped here
# PipeWire might still show 100% — the hardware is the bottleneck
```

**Fix it:**

```bash
# Reset USB device hardware mixer to 100%
# Replace N with the card number from pactl list sinks
amixer -c N set PCM 100%

# Find your card number:
#   pactl list sinks | grep -E "Name|Card"
# Example (replace N with your card number):
# amixer -c N set PCM 100%
```

**Why it happens:** The physical volume wheel/knob on the device adjusts the ALSA mixer directly. This is below PipeWire's visibility — PipeWire shows 100% regardless. If the hardware knob gets bumped (or a game/app adjusts ALSA directly), the max possible volume drops silently.

**Persistence:** USB audio devices initialize their hardware mixer from device firmware on connection. The fix applies immediately and lasts as long as the device stays connected. On reconnect, it'll go to the device's default (usually 100%). If you need to force it on every boot, add the `amixer` commands to a startup script. On Bazzite, use KDE's Autostart (System Settings → Startup and Shutdown) to run the fix on login.
