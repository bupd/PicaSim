#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

case "$(uname -m)" in
  x86_64) preset=linux-x64 ;;
  aarch64|arm64) preset=linux-arm64 ;;
  *) printf '%s\n' "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

if command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --needed --noconfirm \
    base-devel git cmake ninja mesa libx11 libxext libxrandr libxcursor \
    libxi libxfixes libxss libxkbcommon alsa-lib libpulse dbus wayland \
    pipewire rsync
fi

git -C "$root" submodule update --init --recursive

cmake --preset "$preset"
cmake --build --preset "$preset-release"

if [ -w /usr/local/bin ]; then
  ln -sf "$root/picasim" /usr/local/bin/picasim
else
  sudo ln -sf "$root/picasim" /usr/local/bin/picasim
fi

printf '%s\n' "Installed. Run: picasim"
