# ADOS Template

Lean bootstrap for the Agentic Development Operating System (ADOS) v4.

## What this provides
- A minimal ADOS file map scaffold
- Lean root control docs (`CLAUDE.md`, `docs/NOW.md`, `docs/TOPICS.md`)
- Pack-first requirements and planning
- Risk-tier session close workflow (`lite|standard|full`)
- Monorepo auto-detection with workspace-aware prompts/defaults
- Slash command templates and hook stubs
- A guided initializer script for repo-specific values
- Native Copier entrypoint (`copier.yml`)
- Foundation overview scaffolding plus a starter bootstrap pack

## Quick start options
1. GitHub template repo: click `Use this template`.
2. `degit`: `npx degit <org>/ados-template my-project`.
3. Copier: `copier copy <path-or-repo>/ados-template <target-dir>`.
4. Existing repo: run `init-ados.sh` against current repo root.

If you run against a non-empty repo with `--force`, the scaffold will merge ADOS
files into that repo. Commit or back up first if you already have `CLAUDE.md`,
`.claude/`, or `docs/` files you want to preserve carefully.

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
  --foundation-overview "Briefly describe the project and what it is trying to achieve"
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
- foundation overview
- monorepo profile (auto-detected, then prompted in interactive mode)

Then it fills placeholders in:
- `CLAUDE.md`
- `docs/NOW.md`
- `docs/TOPICS.md`
- `docs/foundation/overview.md`
- `docs/topics/bootstrap/*`

After init:
- fill `docs/foundation/overview.md`
- use `/project:pack-create [topic-slug] [purpose]` or create the first real pack manually
- update `docs/NOW.md` and `docs/TOPICS.md` so the real pack becomes active and
  `bootstrap` becomes reference-only

The scaffold defaults to risk-tier session close behavior:
- `lite`: small low-risk changes (default when safe)
- `standard`: normal feature work
- `full`: high-risk/cross-cutting/release-critical work

Documentation defaults:
- Root control docs: `docs/NOW.md` + `docs/TOPICS.md`
- Shared cross-pack context: `docs/foundation/overview.md`
- Canonical seam requirements and plans: `docs/topics/<slug>/`
- Cross-pack/system diagrams: `docs/foundation/diagrams/`
- Pack-local diagrams: `docs/topics/<slug>/diagrams/`

## Guardrails
- `TEMPLATE_VERSION` is included for upgrade tracking.
- `CLAUDE.md` is intentionally lean and imports only `@docs/foundation/overview.md`.

## Self-test

```bash
bash ados-template/scripts/smoke-test.sh
```
