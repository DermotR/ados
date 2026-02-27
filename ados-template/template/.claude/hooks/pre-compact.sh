#!/usr/bin/env bash
set -euo pipefail

backup_dir=".claude/transcript-backups"
mkdir -p "${backup_dir}"

echo "[info] Pre-compact hook ran at $(date -u +%FT%TZ)" > "${backup_dir}/$(date +%Y%m%d-%H%M%S).txt"
