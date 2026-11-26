#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/config"

# real locations to back up
SOURCES=(
  /etc/nixos/flake.nix
  /etc/nixos/flake.lock
  /etc/nixos/configuration.nix
  /etc/nixos/hardware-configuration.nix
  /etc/tlp.conf
  "$HOME/.config/hypr"
  "$HOME/.config/wallpapers"
  "$HOME/.config/waybar"
  "$HOME/.config/nvim"
  "$HOME/.config/kitty"
  "$HOME/.config/hyprlauncher"
  "$HOME/.config/fastfetch"
)

cd "$REPO"

for src in "${SOURCES[@]}"; do
  src="${src%/}"
  name=$(basename "$src")
  [ -e "$src" ] || { echo "skipping missing: $src"; continue; }

  # remove old symlink or stale copy so we never write through a link
  rm -rf "./$name"

  # -L follows any symlinks inside, so real content is copied
  cp -rL "$src" "./$name"
done

git add -A
if git diff --cached --quiet; then
  echo "nothing changed"
else
  git commit -m "Backup $(date '+%Y-%m-%d %H:%M')"
  git push
fi
