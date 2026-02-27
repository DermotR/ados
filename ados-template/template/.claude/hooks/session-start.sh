#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "[warn] Uncommitted changes present at session start."
fi

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
if [[ "${branch}" == "main" || "${branch}" == "master" ]]; then
  echo "[warn] You are on ${branch}. Use a feature branch."
fi
