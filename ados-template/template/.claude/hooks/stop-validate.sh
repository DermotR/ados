#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f docs/NOW.md ]]; then
  echo "[warn] Missing docs/NOW.md"
fi

if [[ ! -f docs/TOPICS.md ]]; then
  echo "[warn] Missing docs/TOPICS.md"
fi

today="$(date +%F)"

has_session_log=0
has_now_update=0
has_pack_cursor_update=0

if [[ -f "docs/sessions/${today}.md" ]]; then
  has_session_log=1
fi

if [[ -f docs/NOW.md ]] && grep -q "${today}" docs/NOW.md; then
  has_now_update=1
fi

if command -v rg >/dev/null 2>&1; then
  if rg -q "${today}" docs/topics/*/cursor.md 2>/dev/null; then
    has_pack_cursor_update=1
  fi
else
  for path in docs/topics/*/cursor.md; do
    [[ -f "${path}" ]] || continue
    if grep -q "${today}" "${path}"; then
      has_pack_cursor_update=1
      break
    fi
  done
fi

if [[ ${has_session_log} -eq 0 && ${has_now_update} -eq 0 && ${has_pack_cursor_update} -eq 0 ]]; then
  echo "[warn] Neither session log, docs/NOW.md, nor any pack cursor shows a ${today} close update."
fi
