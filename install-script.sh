#!/usr/bin/env bash
set -euo pipefail

# Refuse to run as root, since $USER and $HOME must point to your normal user
if [[ $EUID -eq 0 ]]; then
    echo "Run this script as your normal user, not with sudo. It will ask for your password when needed."
    exit 1
fi

# ask "Question" -> returns 0 for yes, 1 for no (default: yes)
ask() {
    local reply
    while true; do
        read -rp "$1 [Y/n] " reply
        case "${reply,,}" in
            ""|y|yes) return 0 ;;
            n|no)     return 1 ;;
            *)        echo "Please answer y or n." ;;
        esac
    done
}

# --needed skips packages that are already installed and up to date
install() {
    sudo pacman -S --needed "$@"
}

# Resolve paths relative to the script, so it works from any directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# copy_config SRC DEST -> backs up DEST if it exists, then copies SRC there
copy_config() {
    local src="$1" dest="$2"

    if [[ ! -e "$src" ]]; then
        echo "Skipping: $src not found"
        return
    fi

    # Back up any existing config instead of overwriting it
    if [[ -e "$dest" ]]; then
        local backup="$dest.bak.$(date +%Y%m%d-%H%M%S)"
        echo "Backing up existing $dest to $backup"
        mv "$dest" "$backup"
    fi

    cp -r "$src" "$dest"
    echo "Copied $src -> $dest"
}

INSTALL_BT=false
INSTALL_VIRT=false

# Ask about optional extras up front so the rest can run unattended
ask "Do you want Bluetooth support?"             && INSTALL_BT=true
ask "Do you want virtualization (libvirt/QEMU)?" && INSTALL_VIRT=true

echo
echo "==> Installing Hyprland"
install hyprland hyprlock hyprpaper wofi kitty nvim yazi pipewire wireplumber ttf-meslo-nerd

echo "==> Copying config files"
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# source folder:target name (Hyprland reads from ~/.config/hypr)
for pair in hyprland:hypr nvim:nvim wofi:wofi waybar:waybar kitty:kitty; do
    copy_config "$SCRIPT_DIR/${pair%%:*}" "$CONFIG_DIR/${pair##*:}"
done

copy_config "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"

if $INSTALL_BT; then
    echo "==> Bluetooth"
    install bluez bluez-utils bluetui
    sudo systemctl enable --now bluetooth.service
fi

if $INSTALL_VIRT; then
    echo "==> Virtualization"
    install libvirt virt-manager qemu-full dnsmasq dmidecode
    sudo systemctl enable --now libvirtd.service virtlogd.service
    sudo usermod -aG libvirt "$USER"
    sudo virsh net-autostart default
    # Don't fail if the network is already running
    sudo virsh net-start default 2>/dev/null || true
    echo "Note: log out and back in for the libvirt group change to take effect."
fi

echo
echo "Done! Run 'source ~/.bashrc' or open a new terminal to load your shell config."
