#!/usr/bin/env bash
# world/model.json の現在の姿を、ビューアごと1枚に書き出す。
#   usage: tools/shot3d.sh world/images/round-008.png
# ローカルHTTPで配る（file:// では model.json を読めない）。
set -euo pipefail

out="${1:?出力先のPNGを指定}"
port="${PORT:-8732}"
chrome="${CHROMIUM:-/opt/pw-browsers/chromium-1194/chrome-linux/chrome}"
root="$(cd "$(dirname "$0")/.." && pwd)"

python3 - "$root" "$port" <<'PY' &
import http.server, os, sys
root, port = sys.argv[1], int(sys.argv[2])
class H(http.server.SimpleHTTPRequestHandler):
    def guess_type(self, path):
        t = super().guess_type(path)
        return t + '; charset=utf-8' if t in ('text/html', 'text/javascript', 'application/javascript', 'application/json') else t
    def log_message(self, *a): pass
os.chdir(root)
http.server.HTTPServer(('127.0.0.1', port), H).serve_forever()
PY
srv=$!
trap 'kill $srv 2>/dev/null || true' EXIT
sleep 1

mkdir -p "$(dirname "$out")"
"$chrome" --headless --no-sandbox --hide-scrollbars --disable-gpu \
  --enable-unsafe-swiftshader --use-gl=swiftshader --force-device-scale-factor=1 \
  --window-size=1600,1000 --virtual-time-budget=9000 \
  --screenshot="$out" "http://127.0.0.1:$port/world/viewer/?still=1" >/dev/null 2>&1
echo "$out"
