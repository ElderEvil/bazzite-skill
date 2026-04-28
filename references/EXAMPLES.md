# Example Requests

**User**: "Install Docker"

**Agent**: On your Bazzite system, you have several options:

1. **Recommended (Podman)**: Bazzite includes Podman natively — Docker-compatible, no setup needed.
   ```bash
   podman --version
   podman run hello-world
   ```

2. **Alternative (Distrobox)**: Run Docker inside a container.
   ```bash
   distrobox create --name docker-host --image fedora:latest
   distrobox enter docker-host
   sudo dnf install docker
   sudo systemctl start docker
   ```

3. **Last Resort (Layering)**: Only if you truly need a host Docker daemon.
   ```bash
   # Pre-check: review current deployment and prepare rollback
   rpm-ostree status
   # Optional safety prep: know how to rollback if needed
   # rpm-ostree rollback && systemctl reboot

   rpm-ostree install docker-ce docker-ce-cli containerd.io
   # Reboot required to apply layered packages
   systemctl reboot
   ```
   ⚠️ This increases image size and update time.

I'd recommend Podman for most use cases. Want me to help set it up?

---

**User**: "Update my system"

**Agent**: On your Bazzite system, updates work differently than traditional distros:

```bash
# Update the OS image
ujust update
# Or manually:
rpm-ostree upgrade

# Update Flatpaks
flatpak update -y

# Check if reboot needed
rpm-ostree status
```

⚠️ If `rpm-ostree upgrade` staged a new deployment, you'll need to reboot to use it. Want me to run these commands?

---

**User**: "Optimize for gaming"

**Agent**: With your NVIDIA GPU on Bazzite, let's optimize gaming performance:

```bash
# Run Bazzite's gaming setup
ujust setup-gaming

# Verify NVIDIA driver
nvidia-smi

# Configure MangoHud overlay
mkdir -p ~/.config/MangoHud
# (creates MangoHud.conf with fps, frametime, cpu/gpu stats)
```

This configures GameMode, MangoHud, Proton-GE, and Steam. Want me to run the gaming setup?

---

**User**: "Install ripgrep"

**Agent**: For `ripgrep` on Bazzite:

```bash
# Check if already installed (Bazzite includes many tools)
which rg || rg --version

# If not found, use Homebrew (preferred for CLI tools)
brew install ripgrep

# Or install inside a Distrobox container (no host changes)
distrobox create --name cli-tools --image fedora:latest
distrobox enter cli-tools
# Inside container: install with the container's package manager
```

Want me to check if it's already installed?

---

**User**: "Set up Python development"

**Agent**: On your Bazzite system, I'll set up Python development using Distrobox to keep the host clean:

```bash
# Create Python development container
distrobox create --name python-dev --image fedora:latest --home ~/containers/python-dev

# Enter and install tools
distrobox enter python-dev
sudo dnf install -y python3 python3-pip python3-virtualenv python3-devel gcc git

# Optional: export Python to host
distrobox-export --bin /usr/bin/python3 --export-path ~/.local/bin
```

Your `~/projects/` directory is accessible from both host and container. Want me to create this container?
