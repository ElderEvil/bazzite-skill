# Bazzite Desktop Skill for OpenCode

A specialized skill that makes OpenCode deeply aware of Bazzite (immutable Fedora) systems and their unique workflows.

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

### Example Interactions

**Installing software:**
```
You: "Install Node.js"

Agent: "On your Bazzite system, I recommend using a Distrobox container...
  [shows distrobox commands instead of dnf]"
```

**System updates:**
```
You: "Update my system"

Agent: "I'll update your Bazzite system. This includes the OS image and Flatpaks...
  [shows rpm-ostree upgrade + flatpak update]"
```

**Gaming setup:**
```
You: "Optimize for gaming"

Agent: "With your RTX 3080, let's run Bazzite's gaming setup...
  [shows ujust setup-gaming]"
```

## File Structure

```
bazzite-skill/
├── AGENTS.md              # Main skill instructions (loaded by OpenCode)
├── README.md              # This file
├── skill.json             # Skill metadata and configuration
├── examples/              # Example prompts and responses
│   ├── install-software.md
│   ├── development-setup.md
│   └── gaming-optimization.md
├── scripts/               # Helper scripts (optional)
│   └── system-info.sh
└── docs/                  # Additional documentation
    ├── rpm-ostree-guide.md
    └── distrobox-patterns.md
```

## Customization

### Updating System Profile

Edit `skill.json` to match your hardware:

```json
"system_profile": {
  "cpu": "Your CPU",
  "ram_gb": 32,
  "gpu": "Your GPU",
  "gpu_vendor": "amd|nvidia|intel"
}
```

### Adding New Behaviors

Extend `AGENTS.md` with:
- New common tasks
- Additional safety rules
- Project-specific workflows

## Philosophy

This skill follows Bazzite's design philosophy:

1. **Immutable First**: Prefer ephemeral changes over permanent ones
2. **Container-First**: Use distrobox/toolbox before layering
3. **Flatpak Native**: Install apps via Flatpak when available
4. **Safety**: Explain consequences before system modifications
5. **Rollback Awareness**: Always know how to undo changes

## Contributing

This is a personal skill tuned for a specific Bazzite installation. Feel free to fork and adapt for your own system.

## License

MIT
