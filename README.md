# Bazzite Desktop Skill for OpenCode

A specialized skill that makes OpenCode deeply aware of Bazzite (immutable Fedora) systems and their unique workflows. Follows the [Agent Skills](https://agentskills.io/) specification for cross-agent compatibility.

## What This Skill Does

This skill transforms OpenCode from a generic Linux assistant into a **Bazzite-native system expert**. It understands:

- Immutable OS architecture (`rpm-ostree`, layering, rebasing)
- Container-first development workflows (`distrobox`, `toolbox`)
- Flatpak as the primary application format
- Bazzite-specific tools (`ujust` recipes)
- Gaming optimizations (Proton, GameMode, MangoHud)
- NVIDIA GPU configuration on immutable systems

## System Profile

This skill is tuned for:
- **OS**: Bazzite (Fedora 43-based)
- **CPU**: AMD Ryzen 7 5800X (16 threads)
- **RAM**: 64 GB
- **GPU**: NVIDIA GeForce RTX 3080
- **Desktop**: KDE Plasma on Wayland

## Installation

### Option 1: OpenCode Skills Directory

Copy or symlink this directory to your OpenCode skills location:

```bash
# Find your opencode skills directory
opencode --skills-dir  # or check ~/.config/opencode/skills/

# Copy the skill
cp -r bazzite-skill ~/.config/opencode/skills/
```

### Option 2: Project-Local

Place `AGENTS.md` in your project root. OpenCode will automatically load it when working in that directory.

## Usage

Once loaded, OpenCode will automatically use Bazzite-aware responses when you:

- Ask about installing software
- Request system configuration
- Need development environment setup
- Want gaming optimizations
- Ask about system maintenance

The skill follows the [Agent Skills specification](https://agentskills.io/specification) — `SKILL.md` contains the YAML frontmatter with `name` and `description` for agent discovery, plus the full skill instructions. `AGENTS.md` is a body mirror for backward compatibility with OpenCode.

## File Structure

```
bazzite-skill/
├── SKILL.md     # Primary skill file (YAML frontmatter + full content)
├── AGENTS.md    # Body mirror of SKILL.md (backward compatibility)
├── README.md    # This file
└── .gitignore
```

## Customization

Edit `SKILL.md` directly to customize the skill. If you make changes, remember to also update `AGENTS.md` to keep them in sync (it should be a body-only mirror of SKILL.md, without the YAML frontmatter).

To update the system profile for your hardware, edit the System Detection section in SKILL.md.

## Philosophy

This skill follows Bazzite's design philosophy:

1. **Immutable First**: Prefer ephemeral changes over permanent ones
2. **Container-First**: Use distrobox/toolbox before layering
3. **Flatpak Native**: Install apps via Flatpak when available
4. **Safety**: Explain consequences before system modifications
5. **Rollback Awareness**: Always know how to undo changes

## License

MIT