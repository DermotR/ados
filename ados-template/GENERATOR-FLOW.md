# Generator Flow

## 1. Scaffold
- Copy `template/` into target project.
- Abort if target is non-empty unless `--force` is set.
- Alternative: use Copier (`copier copy ...`) with `copier.yml`.
- Detect monorepo signals in target repo before rendering defaults.

## 2. Prompt (repo-specific only)
- Project name
- Project stage
- Tech stack summary
- Commands: build/dev/lint/typecheck/format/test
- Key paths summary
- Product overview (short problem statement)
- Monorepo profile (auto-detected; workspace tool/scope)

This can run:
- interactively (`init-ados.sh`)
- non-interactively (flags to `init-ados.sh`)
- via Copier prompts (`copier.yml`)

## 3. Render placeholders
Replace placeholders in:
- `CLAUDE.md`
- `docs/.session-cursor.md`
- `docs/context/core.md`
- `docs/backlog-active.md`
- `docs/spec/product-overview.md`
- `docs/spec/business-rules.md`
- `docs/spec/use-cases.md`

Rendering is handled by `template/.ados/render-ados.sh`.

## 4. Validate lean defaults
- Warn if `CLAUDE.md` exceeds 80 lines.
- Warn if `CLAUDE.md` imports `docs/backlog.md`.

## 5. Hand-off
Print next steps:
1. Fill first active backlog items.
2. Fill `docs/spec/` baseline (use cases + business rules).
3. Run `/project:session-start`.
4. Use `/project:session-end [lite|standard|full]` with risk-tier defaults.
5. Commit scaffold.
