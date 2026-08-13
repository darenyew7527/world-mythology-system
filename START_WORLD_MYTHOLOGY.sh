#!/usr/bin/env sh
set -eu

PROJECT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$PROJECT_DIR"

if [ ! -f web/dist/index.html ]; then
  echo "[World Mythology System] Building the local website for first use..."
  command -v npm >/dev/null 2>&1 || {
    echo "Node.js and npm are required because the prebuilt website is missing." >&2
    exit 1
  }
  (cd web && npm install && npm run build)
fi

WM_PORT=8765
WM_URL="http://127.0.0.1:${WM_PORT}/"

if command -v open >/dev/null 2>&1; then
  open "$WM_URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$WM_URL" >/dev/null 2>&1 || true
fi

echo "Open ${WM_URL} — press Ctrl+C to stop."
python3 -m http.server "$WM_PORT" --bind 127.0.0.1 --directory web/dist
