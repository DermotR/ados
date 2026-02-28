#!/usr/bin/env bash
set -euo pipefail

REQUIRE_COPIER=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --require-copier)
      REQUIRE_COPIER=1
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${REPO_ROOT}"

echo "[1/6] Shell syntax checks"
bash -n ados-template/scripts/init-ados.sh
bash -n ados-template/template/.ados/render-ados.sh

assert_template_result() {
  local dir="$1"
  local expected_mode="$2"
  local expected_tool="$3"

  test -f "${dir}/CLAUDE.md"
  test -f "${dir}/docs/backlog-active.md"
  test -f "${dir}/docs/context/core.md"
  test -f "${dir}/docs/.session-cursor.md"
  test -f "${dir}/.claude/commands/session-end.md"

  if [[ -d "${dir}/.ados" ]]; then
    echo "Expected .ados to be removed after render in ${dir}" >&2
    exit 1
  fi

  if command -v rg >/dev/null 2>&1; then
    if rg -n "__[A-Z_]+__" "${dir}" >/dev/null; then
      echo "Found unreplaced placeholders in ${dir}" >&2
      rg -n "__[A-Z_]+__" "${dir}" || true
      exit 1
    fi
  else
    if grep -R -n "__[A-Z_][A-Z_]*__" "${dir}" >/dev/null 2>&1; then
      echo "Found unreplaced placeholders in ${dir}" >&2
      grep -R -n "__[A-Z_][A-Z_]*__" "${dir}" || true
      exit 1
    fi
  fi

  local claudeline
  claudeline="$(wc -l < "${dir}/CLAUDE.md" | tr -d ' ')"
  if [[ "${claudeline}" -gt 80 ]]; then
    echo "CLAUDE.md exceeds 80 lines in ${dir}: ${claudeline}" >&2
    exit 1
  fi

  if ! grep -q "/project:session-end \\[lite|standard|full\\]" "${dir}/CLAUDE.md"; then
    echo "CLAUDE.md missing v3 close-mode protocol line in ${dir}" >&2
    exit 1
  fi

  if ! grep -q "Close mode: \`lite | standard | full\`" "${dir}/.claude/commands/session-end.md"; then
    echo "session-end command missing close-mode classifier in ${dir}" >&2
    exit 1
  fi

  if ! grep -q "Monorepo mode: ${expected_mode}" "${dir}/CLAUDE.md"; then
    echo "CLAUDE.md has unexpected monorepo mode in ${dir}" >&2
    exit 1
  fi

  if ! grep -q "Monorepo mode: ${expected_mode}" "${dir}/docs/context/core.md"; then
    echo "core.md has unexpected monorepo mode in ${dir}" >&2
    exit 1
  fi

  if ! grep -q "Monorepo mode: ${expected_mode}" "${dir}/docs/.session-cursor.md"; then
    echo "session-cursor has unexpected monorepo mode in ${dir}" >&2
    exit 1
  fi

  if ! grep -q "Workspace tool: ${expected_tool}" "${dir}/CLAUDE.md"; then
    echo "CLAUDE.md has unexpected workspace tool in ${dir}" >&2
    exit 1
  fi
}

cleanup() {
  rm -rf "${TMP_INIT_DIR:-}" "${TMP_MONO_DIR:-}" "${TMP_COPIER_DIR:-}"
}
trap cleanup EXIT

echo "[2/6] init-ados non-interactive scaffold"
TMP_INIT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ados-init-smoke.XXXXXX")"
bash ados-template/scripts/init-ados.sh \
  --target "${TMP_INIT_DIR}" \
  --non-interactive \
  --project-name "Smoke Project" \
  --project-stage "MVP" \
  --tech-stack "TypeScript, Node" \
  --build-cmd "npm run build" \
  --dev-cmd "npm run dev" \
  --lint-cmd "npm run lint" \
  --typecheck-cmd "npm run typecheck" \
  --format-cmd "npm run format:check" \
  --test-cmd "npm test" \
  --key-paths "src, docs" \
  --audit-date "2026-02-27" >/dev/null
assert_template_result "${TMP_INIT_DIR}" "disabled" "none"

echo "[3/6] init-ados monorepo auto-detection"
TMP_MONO_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ados-mono-smoke.XXXXXX")"
cat > "${TMP_MONO_DIR}/pnpm-workspace.yaml" <<'EOF_PNPM'
packages:
  - "apps/*"
  - "packages/*"
EOF_PNPM

bash ados-template/scripts/init-ados.sh \
  --target "${TMP_MONO_DIR}" \
  --force \
  --non-interactive \
  --project-name "Mono Smoke Project" \
  --project-stage "MVP" \
  --tech-stack "TypeScript, pnpm workspace" \
  --key-paths "apps, packages, docs" >/dev/null
assert_template_result "${TMP_MONO_DIR}" "enabled" "pnpm"

echo "[4/6] Copier availability check"
if ! command -v copier >/dev/null 2>&1; then
  if [[ "${REQUIRE_COPIER}" -eq 1 ]]; then
    echo "Copier is required but not installed" >&2
    exit 1
  fi
  echo "Copier not installed; skipping copier smoke test"
  echo "[5/6] Copier smoke test: skipped"
  echo "[6/6] Result: PASS (without copier)"
  exit 0
fi

echo "[5/6] Copier scaffold"
TMP_COPIER_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ados-copier-smoke.XXXXXX")"
copier copy "${REPO_ROOT}/ados-template" "${TMP_COPIER_DIR}" --defaults --trust >/dev/null
assert_template_result "${TMP_COPIER_DIR}" "disabled" "none"

echo "[6/6] Result: PASS"
