---
name: bazzite-skill
description: >
  Bazzite immutable OS desktop assistant with deep system context awareness.
  Use when editing ~/.config/ on Bazzite, managing rpm-ostree, flatpak,
  distrobox, ujust, gaming, GPU drivers, or KDE Plasma. Triggers: Bazzite,
  rpm-ostree, immutable, flatpak, distrobox, ujust, gaming, driver,
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
- Configuring GPU drivers, GPU settings, or gaming optimizations
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
3. **Prefer** Flatpak → Distrobox → Homebrew/uv/pnpm → rpm-ostree layering (in that order). Layering is LAST RESORT.
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
| **GPU drivers** | Proprietary GPU drivers via akmods | `/etc/modprobe.d/`, `gpu-settings` |
| **Wayland session** | Display server protocol | `$WAYLAND_DISPLAY`, KDE Plasma settings |
| **ujust** | Bazzite recipe runner (`just` command wrapper) | `/usr/share/just/` (read-only) |
| **uv** | Ultra-fast Python package manager | `~/.local/bin/`, inside Distrobox |
| **pnpm** | Fast, disk space-efficient Node package manager | `~/.local/bin/`, inside Distrobox |
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
| `uv` | Fast Python package manager | `uv pip install`, `uv venv` |
| `pnpm` | Node.js package manager | `pnpm add`, `pnpm install` |
| `brew` | CLI tool installation | `brew install ripgrep` |

## Package Hierarchy

### The Bazzite Way to Install Software

Bazzite's immutable architecture requires a different mental model than traditional Linux. Follow this hierarchy **in order**:

1. **Flatpak** — Desktop applications (browsers, IDEs, games, media apps). Sandboxed, auto-updating, zero host pollution.
2. **Distrobox** — Development tools, language runtimes, CLI utilities that need a full package manager. Isolated, reproducible, exportable to host.
3. **uv/pnpm** — Fast package managers for Python/Node.js inside Distrobox. No host pollution, no reboot needed.
4. **Homebrew (brew)** — CLI tools that don't need a full container. Lightweight, user-space, no reboot needed.
5. **rpm-ostree layering** — System services, kernel modules, drivers. **LAST RESORT.** Requires reboot, increases image size, complicates updates.

| Scenario | Recommendation | Why |
|----------|---------------|-----|
| Desktop app (browser, IDE, media) | Flatpak | Sandboxed, auto-updates |
| CLI tool (ripgrep, jq, fzf) | Distrobox, uv, or Brew | No host pollution |
| System service (docker daemon, nginx) | Layer | Needs host integration |
| Kernel module | Layer | Must be in base image |
| Driver (GPU, custom) | Layer | Requires system-level access |
| Development environment | Distrobox | Isolated dependencies |
| Game | Flatpak/Steam | Official support |
| Python runtime | Distrobox + uv | Version isolation |
| Node.js runtime | Distrobox + pnpm | Version isolation |

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

# 2. Enter and install tools (dnf only works inside Distrobox)
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

## Decision Framework

When user requests system changes, follow this flow:

1. **Is it a desktop app?** → Flatpak (`flatpak install flathub <app>`)
2. **Is it a CLI tool?** → Distrobox, uv, pnpm, or Brew
3. **Is it a system service or driver?** → rpm-ostree layer (**warn about reboot**)
4. **Is it gaming-related?** → `ujust setup-gaming` + GPU tweaks
5. **Is it a KDE Plasma config?** → Edit `~/.config/` directly
6. **Not sure?** → Check `ujust --list` first, then `rpm-ostree status`

## Out of Scope

This skill intentionally does not cover:

- **Bazzite image building** — Creating custom Bazzite ISOs or OCI images
- **ujust recipe development** — Writing new `/usr/share/just/` recipes
- **bootc** — Bootable container workflows (too early, Bazzite still uses rpm-ostree)
- **Modifying `/usr` on host** — The filesystem is immutable; this is by design
- **Container runtime management** — Podman/Docker daemon configuration (use Distrobox instead)

## References

Load these files on demand when the relevant topic arises:

- [Common Tasks](references/COMMON_TASKS.md) — System detection, updates, software installation, development setup, gaming optimization, GPU config, Flatpak management, uv/pnpm/Homebrew setup
- [Troubleshooting](references/TROUBLESHOOTING.md) — rpm-ostree, Flatpak, Distrobox, GPU, Wayland issues; rollback and cleanup procedures
- [Examples](references/EXAMPLES.md) — Sample agent responses for common user requests
