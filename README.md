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

### Option 1: Global Skill Installation (Recommended)

1. **Clone the repository** and copy only the skill files into your Claude skills directory:
   ```bash
   git clone <repository-url> bazzite-skill
   mkdir -p ~/.claude/skills/bazzite-skill/references
   cp bazzite-skill/SKILL.md ~/.claude/skills/bazzite-skill/
   cp bazzite-skill/AGENTS.md ~/.claude/skills/bazzite-skill/
   cp bazzite-skill/README.md ~/.claude/skills/bazzite-skill/
   cp bazzite-skill/references/*.md ~/.claude/skills/bazzite-skill/references/
   ```

   The cloned directory can be deleted whenever you want — the canonical copy lives in `~/.claude/skills/`.

2. **(Optional) Symlink for other agents** — if you also use OpenCode, Gemini CLI, Codex, or similar tools that support skills:
   ```bash
   ln -s ~/.claude/skills/bazzite-skill ~/.config/opencode/skills/bazzite-skill
   # Or for other agents:
   # ln -s ~/.claude/skills/bazzite-skill ~/.config/gemini/skills/bazzite-skill
   ```

   This keeps `~/.claude/skills/bazzite-skill` as the canonical copy and avoids duplication.

### Option 2: Project-Local

Place `AGENTS.md` in your project root. OpenCode will automatically load it when working in that directory.

## Usage

Once loaded, OpenCode will automatically use Bazzite-aware responses when you:

- Ask about installing software
- Request system configuration
- Need development environment setup
- Want gaming optimizations
- Ask about system maintenance

The skill follows the [Agent Skills specification](https://agentskills.io/specification) — `SKILL.md` contains the YAML frontmatter with `name` and `description` for agent discovery, plus the core instructions. Detailed procedures live in `references/` and are loaded on demand. `AGENTS.md` is a body mirror for backward compatibility with OpenCode.

## File Structure

```text
bazzite-skill/
├── SKILL.md                    # Primary skill file (YAML frontmatter + core instructions)
├── AGENTS.md                   # Body mirror of SKILL.md (backward compatibility)
├── README.md                   # This file
├── references/
│   ├── COMMON_TASKS.md         # System detection, updates, installs, dev setup, gaming, NVIDIA
│   ├── TROUBLESHOOTING.md      # rpm-ostree, Flatpak, Distrobox, NVIDIA, Wayland issues
│   └── EXAMPLES.md             # Sample agent responses for common requests
└── .gitignore
```

## Customization

Edit `SKILL.md` directly to customize the skill. If you make changes, remember to also update `AGENTS.md` to keep them in sync (it should be a body-only mirror of SKILL.md, without the YAML frontmatter).

To update the system profile for your hardware, edit the System Detection section in `references/COMMON_TASKS.md`.

## Philosophy

This skill follows Bazzite's design philosophy:

1. **Immutable First**: Prefer ephemeral changes over permanent ones
2. **Container-First**: Use distrobox/toolbox before layering
3. **Flatpak Native**: Install apps via Flatpak when available
4. **Safety**: Explain consequences before system modifications
5. **Rollback Awareness**: Always know how to undo changes

## License

MIT