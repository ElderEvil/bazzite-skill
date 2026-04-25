# Example: Gaming Optimization

## Scenario: Optimize System for Gaming

### User Prompt
"Optimize my system for gaming"

### Skill-Enhanced Response

With your **NVIDIA RTX 3080** and **64GB RAM** on Bazzite, you're already in great shape! Let me run Bazzite's gaming optimizations and configure a few extras.

#### Step 1: Run Bazzite Gaming Setup

```bash
ujust setup-gaming
```

This typically configures:
- **GameMode**: CPU governor, I/O priority, GPU performance mode
- **MangoHud**: Performance overlay (FPS, temps, frametime)
- **Proton-GE**: Latest GloriousEggroll Proton build
- **Steam**: Installs/updates Steam if needed
- **Lutris**: Game launcher for non-Steam games

#### Step 2: NVIDIA-Specific Optimizations

```bash
# Check current NVIDIA settings
nvidia-smi

# Enable performance mode
sudo nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'

# For Wayland/KDE, ensure these are set:
# - NVIDIA DRM modeset: enabled (should be by default on Bazzite)
cat /proc/driver/nvidia/gpus/*/information
```

#### Step 3: Gaming Tweaks

```bash
# Enable Steam shader pre-caching
# (Steam → Settings → Shader Pre-Caching)

# Set CPU governor to performance (done by GameMode, but verify)
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | head -n 1
# Should show: performance

# Check I/O scheduler
cat /sys/block/nvme*/queue/scheduler 2>/dev/null || \
cat /sys/block/sda/queue/scheduler
# Should include: mq-deadline or none (for NVMe)
```

#### Step 4: MangoHud Configuration

```bash
# Create MangoHud config
mkdir -p ~/.config/MangoHud
cat > ~/.config/MangoHud/MangoHud.conf << 'EOF'
# Basic overlay
fps
frametime
cpu_stats
gpu_stats
ram
vram

# Position
position=top-left

# Style
background_alpha=0.5
font_size=18
text_color=FFFFFF
EOF
```

#### Step 5: Game-Specific Launch Options

Common Steam launch options for your RTX 3080:

```bash
# For most games (enables GameMode + MangoHud)
gamemoderun mangohud %command%

# For games needing extra performance
gamemoderun mangohud %command% -high +fps_max 0

# For DLSS/FSR games (4K recommendation with RTX 3080)
gamemoderun mangohud %command% -dlss_quality balanced
```

#### Step 6: Storage Optimization

With Bazzite's immutable system, game storage management:

```bash
# Check available space (important for large games)
df -h /home

# Bazzite games typically go to:
# - Steam: ~/.local/share/Steam/steamapps
# - Lutris: ~/Games
# - Heroic: ~/.config/heroic

# Consider moving games to secondary drive:
# 1. Mount secondary drive in /etc/fstab
# 2. Symlink steamapps: ln -s /mnt/games/steamapps ~/.local/share/Steam/steamapps
```

#### Verification

Let's verify everything is working:

```bash
# Check GameMode status
gamemoded -s

# Test MangoHud
mangohud vkcube  # Should show overlay

# Check NVIDIA performance
nvidia-smi -q -d PERFORMANCE

# Verify Proton-GE is installed
ls ~/.local/share/Steam/compatibilitytools.d/
```

#### Expected Performance (RTX 3080)

With your hardware, expect:
- **1080p**: 120-240+ FPS in most titles (Ultra)
- **1440p**: 100-180 FPS in most titles (Ultra/High)
- **4K**: 60-120 FPS with DLSS (High/Ultra)

Want me to run the gaming setup and verify everything?

---

## Scenario: Install and Configure a New Game

### User Prompt
"Help me install Cyberpunk 2077"

### Skill-Enhanced Response

For Cyberpunk 2077 on your RTX 3080 with Bazzite:

#### Via Steam (Recommended)

1. Open Steam (should already be installed)
2. Purchase/download Cyberpunk 2077
3. **Before first launch**, set Proton to Proton-GE:
   - Right-click game → Properties → Compatibility
   - Check "Force the use of a specific Steam Play compatibility tool"
   - Select "Proton-GE-latest"

4. **Launch Options** (for RTX 3080):
   ```
   gamemoderun mangohud %command% --launcher-skip
   ```

#### Optimal Settings for RTX 3080

For your GPU at 1440p/4K:
- **Ray Tracing**: Medium/High (RTX 3080 handles it well)
- **DLSS**: Quality or Balanced
- **Field of View**: 80-90
- **Crowd Density**: Medium (CPU-intensive)

#### Troubleshooting

If you encounter issues:

```bash
# Verify NVIDIA drivers
nvidia-smi

# Check for Vulkan compatibility
vulkaninfo | head -n 20

# Common fix: Reset Proton prefix
rm -rf ~/.local/share/Steam/steamapps/compatdata/1091500
# (1091500 is Cyberpunk's Steam ID)
```

Ready to proceed with the installation?
