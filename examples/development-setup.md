# Example: Development Environment Setup

## Scenario: Setting up a Python Development Environment

### User Prompt
"Set up Python development environment"

### Skill-Enhanced Response

On your Bazzite system with 64GB RAM, I'll set up a robust Python development environment using **Distrobox**. This keeps your host system clean while giving you full development capabilities.

#### Step 1: Create Python Development Container

```bash
distrobox create \
  --name python-dev \
  --image fedora:latest \
  --home ~/containers/python-dev
```

#### Step 2: Enter and Configure

```bash
distrobox enter python-dev

# Inside container:
sudo dnf install -y \
  python3 \
  python3-pip \
  python3-virtualenv \
  python3-devel \
  gcc \
  gcc-c++ \
  make \
  git

# Install pyenv for version management
curl https://pyenv.run | bash

# Add to shell config
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
```

#### Step 3: Install Python Versions

```bash
# Install latest Python 3.12
pyenv install 3.12
pyenv global 3.12

# Verify
python --version  # Python 3.12.x
```

#### Step 4: Export IDE Integration (Optional)

```bash
# Export Python to host (so IDEs can find it)
distrobox-export --bin ~/.pyenv/shims/python --export-path ~/.local/bin

# Or set up VS Code in the same container
distrobox-export --app code
```

#### Step 5: Create Project Template

```bash
# Create a new project
mkdir -p ~/projects/my-python-app
cd ~/projects/my-python-app

# Set up virtual environment
python -m venv .venv
source .venv/bin/activate

# Install common tools
pip install \
  black \
  flake8 \
  pytest \
  mypy \
  ipython \
  jupyter

# Create basic structure
mkdir -p src tests
touch src/__init__.py
touch tests/__init__.py
```

#### Access from Host

Your container integrates with the host:
- Files are accessible from both host and container
- GUI apps work via Wayland/X11 forwarding
- VS Code (Flatpak) can use the container's Python interpreter

#### Daily Workflow

```bash
# Quick enter
distrobox enter python-dev

# Or use distrobox-enter shortcut
distrobox-enter python-dev -- python ~/projects/my-python-app/src/main.py
```

---

## Scenario: Full-Stack Web Development

### User Prompt
"Set up full-stack dev environment with Node.js and PostgreSQL"

### Skill-Enhanced Response

For full-stack development on your Bazzite system, I'll create a comprehensive containerized environment.

#### Architecture

```
Host (Bazzite)
├── Distrobox: node-dev (Node.js, npm, yarn)
├── Distrobox: db-dev (PostgreSQL, Redis)
└── Flatpak: VS Code, Postman, Firefox Dev
```

#### Setup

```bash
# Node.js Container
distrobox create --name node-dev --image node:20
distrobox enter node-dev
# Inside: npm install -g @angular/cli typescript ts-node nodemon

# Database Container
distrobox create --name db-dev --image postgres:16
distrobox enter db-dev
# Inside: Configure PostgreSQL, create databases

# Or use Podman containers for databases (more standard)
podman run -d \
  --name postgres-dev \
  -e POSTGRES_PASSWORD=devpass \
  -e POSTGRES_DB=devdb \
  -p 5432:5432 \
  postgres:16

podman run -d \
  --name redis-dev \
  -p 6379:6379 \
  redis:7
```

#### Integration

Your Node.js container can connect to databases via `host.containers.internal`:

```javascript
// Database config
const config = {
  host: 'host.containers.internal',
  port: 5432,
  database: 'devdb',
  user: 'postgres',
  password: 'devpass'
};
```

Want me to set this up for you?
