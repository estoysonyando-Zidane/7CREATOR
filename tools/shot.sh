#!/usr/bin/env bash
# 世界の様子を1枚の絵として書き出す。
#   usage: tools/shot.sh world/scenes/round-005.html world/images/round-005.png
#
# 注意：このChromiumはウィンドウ高から約75px引いた高さまでしか描画しない。
# 書き出しは1600x1000だが、描いてよいのは y<920 まで。下端は黒帯になる。
set -euo pipefail

src="$1"
out="$2"
chrome="${CHROMIUM:-/opt/pw-browsers/chromium-1194/chrome-linux/chrome}"

mkdir -p "$(dirname "$out")"
"$chrome" --headless --disable-gpu --no-sandbox --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1600,1000 \
  --screenshot="$out" "file://$(realpath "$src")" >/dev/null 2>&1
echo "$out"
