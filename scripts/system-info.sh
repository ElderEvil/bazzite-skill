#!/bin/bash
# System info collector for Bazzite Desktop Skill
# Run this to update system context in skill.json

set -euo pipefail

echo "=== Bazzite System Info Collector ==="
echo

# Basic info
echo "Gathering system information..."

HOSTNAME=$(hostname)
KERNEL=$(uname -r)
ARCH=$(uname -m)
CPU=$(grep 'model name' /proc/cpuinfo | head -n 1 | cut -d':' -f2 | xargs)
CORES=$(nproc)
RAM=$(free -h | awk '/^Mem:/ {print $2}')

# GPU info
GPU=$(lspci | grep -i vga | cut -d':' -f3 | xargs || echo "Unknown")
GPU_VENDOR=$(cat /sys/class/drm/card*/device/vendor 2>/dev/null | head -n 1 || echo "unknown")
case "$GPU_VENDOR" in
    0x10de) GPU_VENDOR_NAME="nvidia" ;;
    0x1002) GPU_VENDOR_NAME="amd" ;;
    0x8086) GPU_VENDOR_NAME="intel" ;;
    *) GPU_VENDOR_NAME="unknown" ;;
esac

# Desktop session
DESKTOP=${XDG_CURRENT_DESKTOP:-"Unknown"}
SESSION=${XDG_SESSION_TYPE:-"Unknown"}

# Bazzite-specific
BAZZITE_IMAGE=$(cat /etc/bazzite/image_name 2>/dev/null || echo "unknown")
BAZZITE_VERSION=$(cat /etc/bazzite/version 2>/dev/null || echo "unknown")

echo
echo "=== Collected Information ==="
echo "Hostname: $HOSTNAME"
echo "Kernel: $KERNEL"
echo "Architecture: $ARCH"
echo "CPU: $CPU"
echo "Cores: $CORES"
echo "RAM: $RAM"
echo "GPU: $GPU"
echo "GPU Vendor: $GPU_VENDOR_NAME"
echo "Desktop: $DESKTOP"
echo "Session: $SESSION"
echo "Bazzite Image: $BAZZITE_IMAGE"
echo "Bazzite Version: $BAZZITE_VERSION"
echo

# Update skill.json if found
SKILL_FILE="skill.json"
if [ -f "$SKILL_FILE" ]; then
    echo "Updating $SKILL_FILE..."
    
    # Create backup
    cp "$SKILL_FILE" "$SKILL_FILE.bak"
    
    # Use Python to update JSON (more reliable than sed for JSON)
    python3 << EOF
import json

with open('$SKILL_FILE', 'r') as f:
    data = json.load(f)

data['context']['system_profile'] = {
    'os': 'Bazzite',
    'base': 'Fedora Silverblue/Kinoite',
    'kernel': '$KERNEL',
    'desktop': '$DESKTOP',
    'session': '$SESSION',
    'cpu': '$CPU',
    'cores': $CORES,
    'ram': '$RAM',
    'gpu': '$GPU',
    'gpu_vendor': '$GPU_VENDOR_NAME',
    'hostname': '$HOSTNAME',
    'bazzite_image': '$BAZZITE_IMAGE',
    'bazzite_version': '$BAZZITE_VERSION'
}

with open('$SKILL_FILE', 'w') as f:
    json.dump(data, f, indent=2)

print("Updated successfully!")
EOF
    
    echo "Backup saved to $SKILL_FILE.bak"
else
    echo "Warning: $SKILL_FILE not found in current directory"
    echo "System profile information:"
    echo
    cat << JSON
{
  "system_profile": {
    "os": "Bazzite",
    "base": "Fedora Silverblue/Kinoite",
    "kernel": "$KERNEL",
    "desktop": "$DESKTOP",
    "session": "$SESSION",
    "cpu": "$CPU",
    "cores": $CORES,
    "ram": "$RAM",
    "gpu": "$GPU",
    "gpu_vendor": "$GPU_VENDOR_NAME",
    "hostname": "$HOSTNAME",
    "bazzite_image": "$BAZZITE_IMAGE",
    "bazzite_version": "$BAZZITE_VERSION"
  }
}
JSON
fi

echo
echo "Done!"
