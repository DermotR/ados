#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: init-ados.sh [TARGET_DIR] [--force]
       init-ados.sh [options]

Options:
  --target DIR               Target directory (default: .)
  --force                    Allow non-empty target directory
  --non-interactive          Skip prompts; use flags/defaults
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
  --monorepo true|false      Force monorepo profile on/off
  --workspace-tool VALUE     e.g. pnpm, turbo, nx, npm-workspaces
  --workspace-scope VALUE    e.g. apps/*, packages/*
  -h, --help                 Show help
USAGE
}

normalize_bool() {
  local lower
  lower="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "${lower}" in
    true|1|yes|y) echo "true" ;;
    false|0|no|n) echo "false" ;;
    *)
      echo "Invalid boolean value: $1 (use true|false)" >&2
      exit 1
      ;;
  esac
}

detect_monorepo() {
  local dir="$1"

  [[ -f "${dir}/pnpm-workspace.yaml" ]] && return 0
  [[ -f "${dir}/turbo.json" ]] && return 0
  [[ -f "${dir}/nx.json" ]] && return 0
  [[ -f "${dir}/lerna.json" ]] && return 0
  [[ -f "${dir}/rush.json" ]] && return 0

  if [[ -f "${dir}/package.json" ]] && grep -Eq '"workspaces"[[:space:]]*:' "${dir}/package.json"; then
    return 0
  fi

  return 1
}

detect_workspace_tool() {
  local dir="$1"

  if [[ -f "${dir}/pnpm-workspace.yaml" ]]; then
    echo "pnpm"
  elif [[ -f "${dir}/turbo.json" ]]; then
    echo "turbo"
  elif [[ -f "${dir}/nx.json" ]]; then
    echo "nx"
  elif [[ -f "${dir}/lerna.json" ]]; then
    echo "lerna"
  elif [[ -f "${dir}/rush.json" ]]; then
    echo "rush"
  elif [[ -f "${dir}/package.json" ]] && grep -Eq '"workspaces"[[:space:]]*:' "${dir}/package.json"; then
    echo "npm-workspaces"
  else
    echo "none"
  fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../template"

TARGET_DIR="."
TARGET_SET=0
FORCE=0
INTERACTIVE=1

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
MONOREPO_FLAG=""
WORKSPACE_TOOL=""
WORKSPACE_SCOPE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TARGET_DIR="$2"
      TARGET_SET=1
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --non-interactive)
      INTERACTIVE=0
      shift
      ;;
    --project-name)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      PROJECT_NAME="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --project-stage)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      PROJECT_STAGE="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --tech-stack)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TECH_STACK="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --build-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      BUILD_CMD="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --dev-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      DEV_CMD="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --lint-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      LINT_CMD="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --typecheck-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TYPECHECK_CMD="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --format-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      FORMAT_CMD="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --test-cmd)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      TEST_CMD="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --key-paths)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      KEY_PATHS="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --audit-date)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      AUDIT_DATE="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --monorepo)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      MONOREPO_FLAG="$(normalize_bool "$2")"
      INTERACTIVE=0
      shift 2
      ;;
    --workspace-tool)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      WORKSPACE_TOOL="$2"
      INTERACTIVE=0
      shift 2
      ;;
    --workspace-scope)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      WORKSPACE_SCOPE="$2"
      INTERACTIVE=0
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ "$1" == -* ]]; then
        echo "Unknown argument: $1" >&2
        usage >&2
        exit 1
      fi
      if [[ ${TARGET_SET} -eq 0 ]]; then
        TARGET_DIR="$1"
        TARGET_SET=1
        shift
      else
        echo "Unexpected positional argument: $1" >&2
        usage >&2
        exit 1
      fi
      ;;
  esac
done

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
  echo "Template directory not found: ${TEMPLATE_DIR}" >&2
  exit 1
fi

if [[ ! -d "${TARGET_DIR}" ]]; then
  echo "Creating target directory: ${TARGET_DIR}"
  mkdir -p "${TARGET_DIR}"
fi

if [[ -n "$(ls -A "${TARGET_DIR}" 2>/dev/null || true)" && ${FORCE} -ne 1 ]]; then
  echo "Target is not empty: ${TARGET_DIR}" >&2
  echo "Re-run with --force if you want to overwrite/merge into an existing directory." >&2
  exit 1
fi

if [[ ! -t 0 ]]; then
  INTERACTIVE=0
fi

prompt_if_missing() {
  local var_name="$1"
  local prompt_text="$2"
  local default_value="$3"
  if [[ -z "${!var_name}" && ${INTERACTIVE} -eq 1 ]]; then
    local input=""
    read -r -p "${prompt_text} [${default_value}]: " input
    printf -v "${var_name}" '%s' "${input}"
  fi
}

prompt_if_missing PROJECT_NAME "Project name" "New Project"
prompt_if_missing PROJECT_STAGE "Project stage (e.g. pre-MVP, MVP, growth)" "MVP"
prompt_if_missing TECH_STACK "Tech stack summary" "TBD"
prompt_if_missing BUILD_CMD "Build command" "npm run build"
prompt_if_missing DEV_CMD "Dev command" "npm run dev"
prompt_if_missing LINT_CMD "Lint command" "npm run lint"
prompt_if_missing TYPECHECK_CMD "Typecheck command" "npm run typecheck"
prompt_if_missing FORMAT_CMD "Format-check command" "npm run format:check"
prompt_if_missing TEST_CMD "Test command" "npm test"
prompt_if_missing KEY_PATHS "Key paths summary (one line)" "src/, tests/, docs/"
prompt_if_missing AUDIT_DATE "Audit date (YYYY-MM-DD)" "$(date +%F)"

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

DETECTED_MONOREPO=false
DETECTED_WORKSPACE_TOOL="none"
if detect_monorepo "${TARGET_DIR}"; then
  DETECTED_MONOREPO=true
  DETECTED_WORKSPACE_TOOL="$(detect_workspace_tool "${TARGET_DIR}")"
fi

MONOREPO_MODE="disabled"
if [[ -n "${MONOREPO_FLAG}" ]]; then
  if [[ "${MONOREPO_FLAG}" == "true" ]]; then
    MONOREPO_MODE="enabled"
  fi
elif [[ "${DETECTED_MONOREPO}" == "true" ]]; then
  if [[ ${INTERACTIVE} -eq 1 ]]; then
    use_mono=""
    read -r -p "Monorepo signals detected (${DETECTED_WORKSPACE_TOOL}). Use monorepo profile? [Y/n]: " use_mono
    use_mono="${use_mono:-Y}"
    use_mono_lower="$(printf '%s' "${use_mono}" | tr '[:upper:]' '[:lower:]')"
    if [[ "${use_mono_lower}" == "y" || "${use_mono_lower}" == "yes" ]]; then
      MONOREPO_MODE="enabled"
    fi
  else
    MONOREPO_MODE="enabled"
  fi
fi

if [[ "${MONOREPO_MODE}" == "enabled" ]]; then
  default_tool="${DETECTED_WORKSPACE_TOOL}"
  [[ "${default_tool}" == "none" ]] && default_tool="pnpm"
  prompt_if_missing WORKSPACE_TOOL "Workspace tool" "${default_tool}"
  prompt_if_missing WORKSPACE_SCOPE "Primary workspace scope" "apps/*, packages/*"
  WORKSPACE_TOOL="${WORKSPACE_TOOL:-${default_tool}}"
  WORKSPACE_SCOPE="${WORKSPACE_SCOPE:-apps/*, packages/*}"
else
  WORKSPACE_TOOL="none"
  WORKSPACE_SCOPE="."
fi

cp -R "${TEMPLATE_DIR}/." "${TARGET_DIR}/"

if [[ ! -f "${TARGET_DIR}/.ados/render-ados.sh" ]]; then
  echo "Expected helper missing: ${TARGET_DIR}/.ados/render-ados.sh" >&2
  exit 1
fi

VALUES_FILE="$(mktemp "${TMPDIR:-/tmp}/ados-values.XXXXXX")"
cleanup() {
  rm -f "${VALUES_FILE}"
}
trap cleanup EXIT

cat > "${VALUES_FILE}" <<EOF_VALUES
PROJECT_NAME=${PROJECT_NAME}
PROJECT_STAGE=${PROJECT_STAGE}
TECH_STACK=${TECH_STACK}
BUILD_CMD=${BUILD_CMD}
DEV_CMD=${DEV_CMD}
LINT_CMD=${LINT_CMD}
TYPECHECK_CMD=${TYPECHECK_CMD}
FORMAT_CMD=${FORMAT_CMD}
TEST_CMD=${TEST_CMD}
KEY_PATHS=${KEY_PATHS}
AUDIT_DATE=${AUDIT_DATE}
MONOREPO_MODE=${MONOREPO_MODE}
WORKSPACE_TOOL=${WORKSPACE_TOOL}
WORKSPACE_SCOPE=${WORKSPACE_SCOPE}
EOF_VALUES

(
  cd "${TARGET_DIR}"
  bash .ados/render-ados.sh --values-file "${VALUES_FILE}"
  rm -rf .ados
)

echo

echo "ADOS scaffold initialized in: ${TARGET_DIR}"
echo "Monorepo profile: ${MONOREPO_MODE} (tool=${WORKSPACE_TOOL}, scope=${WORKSPACE_SCOPE})"
echo "Next steps:"
echo "1) Fill docs/backlog-active.md with current milestone + 3-10 items."
echo "2) Review CLAUDE.md command values and key paths."
echo "3) Run /project:session-start, then close with /project:session-end [lite|standard|full]."
echo "4) Commit bootstrap files."
