#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: render-ados.sh [options]

Options:
  --values-file PATH        Load KEY=VALUE pairs
  --project-name VALUE
  --project-stage VALUE
  --tech-stack VALUE
  --build-cmd VALUE
  --dev-cmd VALUE
  --lint-cmd VALUE
  --typecheck-cmd VALUE
  --format-cmd VALUE
  --test-cmd VALUE
  --key-paths VALUE
  --audit-date YYYY-MM-DD
  --monorepo-mode VALUE     enabled|disabled
  --workspace-tool VALUE
  --workspace-scope VALUE
  -h, --help                Show help
USAGE
}

normalize_mode() {
  local lower
  lower="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "${lower}" in
    enabled|true|1|yes|y) echo "enabled" ;;
    disabled|false|0|no|n) echo "disabled" ;;
    *)
      echo "Invalid monorepo mode: $1 (use enabled|disabled)" >&2
      exit 1
      ;;
  esac
}

VALUES_FILE=""
PROJECT_NAME=""
PROJECT_STAGE=""
TECH_STACK=""
BUILD_CMD=""
DEV_CMD=""
LINT_CMD=""
TYPECHECK_CMD=""
FORMAT_CMD=""
TEST_CMD=""
KEY_PATHS=""
AUDIT_DATE=""
MONOREPO_MODE=""
WORKSPACE_TOOL=""
WORKSPACE_SCOPE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --values-file)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      VALUES_FILE="$2"
      shift 2
      ;;
    --project-name)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      PROJECT_NAME="$2"
      shift 2
      ;;
    --project-stage)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      PROJECT_STAGE="$2"
      shift 2
      ;;
    --tech-stack)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TECH_STACK="$2"
      shift 2
      ;;
    --build-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      BUILD_CMD="$2"
      shift 2
      ;;
    --dev-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      DEV_CMD="$2"
      shift 2
      ;;
    --lint-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      LINT_CMD="$2"
      shift 2
      ;;
    --typecheck-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TYPECHECK_CMD="$2"
      shift 2
      ;;
    --format-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      FORMAT_CMD="$2"
      shift 2
      ;;
    --test-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TEST_CMD="$2"
      shift 2
      ;;
    --key-paths)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      KEY_PATHS="$2"
      shift 2
      ;;
    --audit-date)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      AUDIT_DATE="$2"
      shift 2
      ;;
    --monorepo-mode)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      MONOREPO_MODE="$(normalize_mode "$2")"
      shift 2
      ;;
    --workspace-tool)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      WORKSPACE_TOOL="$2"
      shift 2
      ;;
    --workspace-scope)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      WORKSPACE_SCOPE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -n "${VALUES_FILE}" ]]; then
  if [[ ! -f "${VALUES_FILE}" ]]; then
    echo "Values file not found: ${VALUES_FILE}" >&2
    exit 1
  fi

  while IFS='=' read -r key value || [[ -n "${key:-}" ]]; do
    [[ -n "${key:-}" ]] || continue
    [[ "${key:0:1}" == "#" ]] && continue
    value="${value%$'\r'}"
    case "$key" in
      PROJECT_NAME) PROJECT_NAME="${PROJECT_NAME:-$value}" ;;
      PROJECT_STAGE) PROJECT_STAGE="${PROJECT_STAGE:-$value}" ;;
      TECH_STACK) TECH_STACK="${TECH_STACK:-$value}" ;;
      BUILD_CMD) BUILD_CMD="${BUILD_CMD:-$value}" ;;
      DEV_CMD) DEV_CMD="${DEV_CMD:-$value}" ;;
      LINT_CMD) LINT_CMD="${LINT_CMD:-$value}" ;;
      TYPECHECK_CMD) TYPECHECK_CMD="${TYPECHECK_CMD:-$value}" ;;
      FORMAT_CMD) FORMAT_CMD="${FORMAT_CMD:-$value}" ;;
      TEST_CMD) TEST_CMD="${TEST_CMD:-$value}" ;;
      KEY_PATHS) KEY_PATHS="${KEY_PATHS:-$value}" ;;
      AUDIT_DATE) AUDIT_DATE="${AUDIT_DATE:-$value}" ;;
      MONOREPO_MODE) MONOREPO_MODE="${MONOREPO_MODE:-$value}" ;;
      WORKSPACE_TOOL) WORKSPACE_TOOL="${WORKSPACE_TOOL:-$value}" ;;
      WORKSPACE_SCOPE) WORKSPACE_SCOPE="${WORKSPACE_SCOPE:-$value}" ;;
    esac
  done < "${VALUES_FILE}"
fi

PROJECT_NAME="${PROJECT_NAME:-New Project}"
PROJECT_STAGE="${PROJECT_STAGE:-MVP}"
TECH_STACK="${TECH_STACK:-TBD}"
BUILD_CMD="${BUILD_CMD:-npm run build}"
DEV_CMD="${DEV_CMD:-npm run dev}"
LINT_CMD="${LINT_CMD:-npm run lint}"
TYPECHECK_CMD="${TYPECHECK_CMD:-npm run typecheck}"
FORMAT_CMD="${FORMAT_CMD:-npm run format:check}"
TEST_CMD="${TEST_CMD:-npm test}"
KEY_PATHS="${KEY_PATHS:-src/, tests/, docs/}"
AUDIT_DATE="${AUDIT_DATE:-$(date +%F)}"
MONOREPO_MODE="${MONOREPO_MODE:-disabled}"
MONOREPO_MODE="$(normalize_mode "${MONOREPO_MODE}")"

if [[ "${MONOREPO_MODE}" == "enabled" ]]; then
  WORKSPACE_TOOL="${WORKSPACE_TOOL:-pnpm}"
  WORKSPACE_SCOPE="${WORKSPACE_SCOPE:-apps/*, packages/*}"
else
  WORKSPACE_TOOL="none"
  WORKSPACE_SCOPE="."
fi

escape() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

PROJECT_NAME_E="$(escape "${PROJECT_NAME}")"
PROJECT_STAGE_E="$(escape "${PROJECT_STAGE}")"
TECH_STACK_E="$(escape "${TECH_STACK}")"
BUILD_CMD_E="$(escape "${BUILD_CMD}")"
DEV_CMD_E="$(escape "${DEV_CMD}")"
LINT_CMD_E="$(escape "${LINT_CMD}")"
TYPECHECK_CMD_E="$(escape "${TYPECHECK_CMD}")"
FORMAT_CMD_E="$(escape "${FORMAT_CMD}")"
TEST_CMD_E="$(escape "${TEST_CMD}")"
KEY_PATHS_E="$(escape "${KEY_PATHS}")"
AUDIT_DATE_E="$(escape "${AUDIT_DATE}")"
MONOREPO_MODE_E="$(escape "${MONOREPO_MODE}")"
WORKSPACE_TOOL_E="$(escape "${WORKSPACE_TOOL}")"
WORKSPACE_SCOPE_E="$(escape "${WORKSPACE_SCOPE}")"

render_file() {
  local path="$1"
  [[ -f "${path}" ]] || return 0
  sed -i.bak \
    -e "s/__PROJECT_NAME__/${PROJECT_NAME_E}/g" \
    -e "s/__PROJECT_STAGE__/${PROJECT_STAGE_E}/g" \
    -e "s/__TECH_STACK__/${TECH_STACK_E}/g" \
    -e "s/__BUILD_CMD__/${BUILD_CMD_E}/g" \
    -e "s/__DEV_CMD__/${DEV_CMD_E}/g" \
    -e "s/__LINT_CMD__/${LINT_CMD_E}/g" \
    -e "s/__TYPECHECK_CMD__/${TYPECHECK_CMD_E}/g" \
    -e "s/__FORMAT_CMD__/${FORMAT_CMD_E}/g" \
    -e "s/__TEST_CMD__/${TEST_CMD_E}/g" \
    -e "s/__KEY_PATHS__/${KEY_PATHS_E}/g" \
    -e "s/__AUDIT_DATE__/${AUDIT_DATE_E}/g" \
    -e "s/__MONOREPO_MODE__/${MONOREPO_MODE_E}/g" \
    -e "s/__WORKSPACE_TOOL__/${WORKSPACE_TOOL_E}/g" \
    -e "s/__WORKSPACE_SCOPE__/${WORKSPACE_SCOPE_E}/g" \
    "${path}"
  rm -f "${path}.bak"
}

render_file "CLAUDE.md"
render_file "docs/.session-cursor.md"
render_file "docs/context/core.md"
render_file "docs/backlog-active.md"
render_file "docs/backlog.md"

CLAUDE_LINES="$(wc -l < "CLAUDE.md" | tr -d ' ')"
if [[ "${CLAUDE_LINES}" -gt 80 ]]; then
  echo "WARNING: CLAUDE.md is ${CLAUDE_LINES} lines (target <= 80)."
fi

if command -v rg >/dev/null 2>&1; then
  if rg -q "@docs/backlog\.md" "CLAUDE.md"; then
    echo "WARNING: CLAUDE.md imports docs/backlog.md; use backlog-active + pointer instead."
  fi
else
  if grep -q "@docs/backlog.md" "CLAUDE.md"; then
    echo "WARNING: CLAUDE.md imports docs/backlog.md; use backlog-active + pointer instead."
  fi
fi

echo "ADOS values rendered into scaffold files."
