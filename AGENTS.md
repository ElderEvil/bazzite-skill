# Bazzite Desktop Skill

## Description

A specialized OpenCode skill for managing and interacting with Bazzite (immutable Fedora) desktop systems. This skill provides deep context awareness of Bazzite's unique architecture, tools, and workflows.

## When to Use This Skill

Load this skill when:
- Working on a Bazzite or Fedora Silverblue/Kinoite system
- Managing immutable OS workflows (rpm-ostree, layering, rebasing)
- Setting up development environments on Bazzite
- Configuring gaming, containers, or desktop customization
- Troubleshooting system-level issues on immutable Fedora

## System Context

### Host Profile
- **OS**: Bazzite (Fedora-based immutable OS)
- **Kernel**: 6.17.7-ba29.fc43.x86_64
- **CPU**: AMD Ryzen 7 5800X (8 cores, 16 threads)
- **RAM**: 64 GB
- **GPU**: NVIDIA GeForce RTX 3080
- **Desktop**: KDE Plasma on Wayland
- **Session**: Wayland

### Bazzite-Specific Knowledge

#### Package Management
- **Primary**: `rpm-ostree` (not dnf/yum)
- **Layering**: `rpm-ostree install <pkg>` (persists across updates)
- **Temporary**: `rpm-ostree usroverlay` (ephemeral overlay)
- **Rollback**: `rpm-ostree rollback`
- **Status**: `rpm-ostree status`
- **Update**: `rpm-ostree upgrade`

#### Container Workflows (Preferred)
- **Distrobox**: Create pet containers for development
  - `distrobox create --name dev --image fedora:latest`
  - `distrobox enter dev`
- **Toolbox**: Alternative container workflow
- **Brew**: Homebrew via `brew` in distrobox or system-wide

#### Bazzite Utilities
- **ujust**: Bazzite's just command runner for common tasks
  - `ujust update` - System update
  - `ujust setup-gaming` - Gaming optimizations
  - `ujust install-steam` - Steam setup
  - `ujust configure-desktop` - Desktop tweaks
- **Bazzite CLI**: Various helper scripts in `/usr/bin/bazzite-*`

#### Flatpak
- **Primary app format** on Bazzite
- `flatpak install flathub <app>`
- `flatpak run <app>`
- `flatpak update`

#### NVIDIA Considerations
- Uses proprietary NVIDIA drivers (akmods)
- Wayland support via GBM backend
- Gaming optimizations available via `ujust`
- CUDA available through layering or distrobox

## Skill Behaviors

### Advisory Mode (Default)
When user asks for help:
1. Explain the Bazzite way to accomplish the task
2. Prefer container/distobox solutions over layering
3. Warn about layering consequences (update size, rollback complexity)
4. Provide step-by-step guidance

### Execution Mode (With Confirmation)
When user asks to perform an action:
1. Explain what will be done and why
2. Show the exact command(s)
3. Ask for confirmation before executing
4. Prefer read-only/dry-run first when possible

### Memory
Remember across sessions:
- User's preferred workflows
- Commonly used distrobox containers
- Layered packages
- System modifications made

## Common Tasks

### Development Environment
```bash
# Preferred: Distrobox
distrobox create --name dev --image fedora:latest
distrobox enter dev
# Inside container: sudo dnf install nodejs golang rust

# Alternative: Layer only if necessary
rpm-ostree install gcc make nodejs
```

### Gaming Setup
```bash
ujust setup-gaming
# Configures gamemode, mangoHUD, proton-ge, etc.
```

### System Update
```bash
ujust update
# Or manually:
rpm-ostree upgrade
flatpak update
```

### Installing Apps
```bash
# Prefer Flatpak
flatpak install flathub com.visualstudio.code

# Or distrobox
# Containerized apps avoid host pollution
```

## Safety Rules

1. **Never** run `rpm-ostree` commands without explaining the consequences
2. **Always** suggest `rpm-ostree status` before making changes
3. **Prefer** flatpak/distrobox over layering
4. **Warn** about reboot requirements after layering
5. **Suggest** rollback procedure before risky operations
6. **Never** suggest `dnf` or `yum` directly on host (use in containers)

## Output Format

- Start with context: "On your Bazzite system..."
- Explain the "why" behind immutable OS choices
- Provide commands in code blocks
- Use admonitions for warnings/notes
- End with next steps or verification command

## Examples

### Example 1: Installing a New Tool
**User**: "I need to install Docker"

**Response**:
On your Bazzite system, you have a few options for Docker:

1. **Recommended (Distrobox)**: Run Docker inside a container
   ```bash
   distrobox create --name docker-host --image fedora:latest
   distrobox enter docker-host
   sudo dnf install docker docker-compose
   sudo systemctl start docker
   ```

2. **Alternative (Podman)**: Bazzite includes Podman natively
   ```bash
   podman --version  # Already installed
   podman run hello-world
   ```
   Podman is Docker-compatible and requires no setup.

3. **Last Resort (Layering)**: Only if you truly need daemon Docker
   ```bash
   rpm-ostree install docker-ce docker-ce-cli containerd.io
   # Requires reboot
   ```
   ⚠️ This will increase your image size and update time.

I'd recommend option 2 (Podman) for most use cases. Want me to help set it up?

### Example 2: System Update
**User**: "Update my system"

**Response**:
On your Bazzite system, updates work differently than traditional distros. Let me update everything:

```bash
# Update the OS image
rpm-ostree upgrade

# Update Flatpaks
flatpak update -y

# Check if reboot needed
rpm-ostree status
```

⚠️ If `rpm-ostree upgrade` installed a new deployment, you'll need to reboot to use it.

Want me to run these commands?

### Example 3: Gaming Optimization
**User**: "Optimize for gaming"

**Response**:
With your RTX 3080 on Bazzite, let's optimize gaming performance:

```bash
# Run Bazzite's gaming setup
ujust setup-gaming

# This typically configures:
# - GameMode (CPU governor, I/O priority)
# - MangoHud (performance overlay)
# - Proton-GE (latest Proton)
# - NVIDIA settings
```

Your RTX 3080 should work great with the proprietary drivers already included in Bazzite. Want me to run the gaming setup?
