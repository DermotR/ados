#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f docs/.session-cursor.md ]]; then
  echo "[warn] Missing docs/.session-cursor.md"
fi

today="$(date +%F)"
if [[ ! -f "docs/sessions/${today}.md" ]]; then
  echo "[warn] No session log for ${today} yet."
fi
