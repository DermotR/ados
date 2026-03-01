# ADOS Template

Lean bootstrap for the Agentic Development Operating System (ADOS) v3.

## What this provides
- A minimal ADOS file map scaffold
- Lean always-loaded defaults (`CLAUDE.md`, `docs/.session-cursor.md`, `docs/context/core.md`)
- Active backlog split (`docs/backlog-active.md` + `docs/backlog.md`)
- Risk-tier session close workflow (`lite|standard|full`)
- Monorepo auto-detection with workspace-aware prompts/defaults
- Slash command templates and hook stubs
- A guided initializer script for repo-specific values
- Native Copier entrypoint (`copier.yml`)
- Spec scaffolding in `docs/spec/` (product overview, use cases, business rules, diagrams)

## Quick start options
1. GitHub template repo: click `Use this template`.
2. `degit`: `npx degit <org>/ados-template my-project`.
3. Copier: `copier copy <path-or-repo>/ados-template <target-dir>`.
4. Existing repo: run `init-ados.sh` against current repo root.

## Guided init
Run from your target repo root:

```bash
bash path/to/ados-template/scripts/init-ados.sh .
```

Non-interactive mode:

```bash
bash path/to/ados-template/scripts/init-ados.sh \
  --target . \
  --non-interactive \
  --project-name "My Project" \
  --project-stage "MVP" \
  --tech-stack "TypeScript, Next.js, Postgres" \
  --build-cmd "pnpm build" \
  --dev-cmd "pnpm dev" \
  --lint-cmd "pnpm lint" \
  --typecheck-cmd "pnpm typecheck" \
  --format-cmd "pnpm format:check" \
  --test-cmd "pnpm test" \
  --key-paths "apps/web, packages/api, docs" \
  --product-overview "Briefly describe the problem this product solves"
```

Monorepo override mode:

```bash
bash path/to/ados-template/scripts/init-ados.sh \
  --target . \
  --non-interactive \
  --monorepo true \
  --workspace-tool pnpm \
  --workspace-scope \"apps/*, packages/*\"
```

The script asks only for:
- project name
- project stage
- tech stack
- build/dev/lint/typecheck/format/test commands
- key paths summary
- product overview
- monorepo profile (auto-detected, then prompted in interactive mode)

Then it fills placeholders in:
- `CLAUDE.md`
- `docs/.session-cursor.md`
- `docs/context/core.md`
- `docs/backlog-active.md`
- `docs/spec/product-overview.md`
- `docs/spec/business-rules.md`
- `docs/spec/use-cases.md`

The scaffold defaults to risk-tier session close behavior:
- `lite`: small low-risk changes (default when safe)
- `standard`: normal feature work
- `full`: high-risk/cross-cutting/release-critical work

Spec location defaults:
- Requirements and scope: `docs/spec/product-overview.md` + `docs/spec/use-cases.md`
- Business constraints: `docs/spec/business-rules.md`
- PlantUML diagrams: `docs/spec/diagrams/`

## Guardrails
- `TEMPLATE_VERSION` is included for upgrade tracking.
- `CLAUDE.md` is intentionally lean and imports only `@docs/context/core.md`.

## Self-test

```bash
bash ados-template/scripts/smoke-test.sh
```
