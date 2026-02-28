#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f docs/.session-cursor.md ]]; then
  echo "[warn] Missing docs/.session-cursor.md"
fi

if [[ ! -f docs/backlog-active.md ]]; then
  echo "[warn] Missing docs/backlog-active.md"
fi

today="$(date +%F)"

has_session_log=0
has_cursor_update=0

if [[ -f "docs/sessions/${today}.md" ]]; then
  has_session_log=1
fi

if [[ -f docs/.session-cursor.md ]] && grep -q "${today}" docs/.session-cursor.md; then
  has_cursor_update=1
fi

if [[ ${has_session_log} -eq 0 && ${has_cursor_update} -eq 0 ]]; then
  echo "[warn] Neither session log nor cursor shows a ${today} close update."
fi
