#!/usr/bin/env bash
# 世界の様子を1枚の絵として書き出す。
#   usage: tools/shot.sh world/scenes/round-005.html world/images/round-005.png
set -euo pipefail

src="$1"
out="$2"
chrome="${CHROMIUM:-/opt/pw-browsers/chromium-1194/chrome-linux/chrome}"

mkdir -p "$(dirname "$out")"
"$chrome" --headless --disable-gpu --no-sandbox --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1600,1000 \
  --screenshot="$out" "file://$(realpath "$src")" >/dev/null 2>&1
echo "$out"
