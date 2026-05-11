#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
vcpkg_root=${VCPKG_ROOT:-$HOME/.local/share/picasim/vcpkg}

git -C "$root" submodule update --init --recursive

if [ ! -x "$vcpkg_root/vcpkg" ]; then
  mkdir -p "$(dirname -- "$vcpkg_root")"
  git clone https://github.com/microsoft/vcpkg.git "$vcpkg_root"
  "$vcpkg_root/bootstrap-vcpkg.sh"
fi

VCPKG_ROOT="$vcpkg_root" cmake --preset linux-x64 \
  -DSDL_PIPEWIRE=OFF \
  -DPICASIM_ENABLE_VR=OFF \
  -DCMAKE_CXX_FLAGS="-DGL_GLEXT_PROTOTYPES"
VCPKG_ROOT="$vcpkg_root" cmake --build --preset linux-x64-release

if [ -w /usr/local/bin ]; then
  ln -sf "$root/picasim" /usr/local/bin/picasim
else
  sudo ln -sf "$root/picasim" /usr/local/bin/picasim
fi

printf '%s\n' "Installed. Run: picasim"
