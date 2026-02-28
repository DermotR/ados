# Generator Flow

## 1. Scaffold
- Copy `template/` into target project.
- Abort if target is non-empty unless `--force` is set.
- Alternative: use Copier (`copier copy ...`) with `copier.yml`.

## 2. Prompt (repo-specific only)
- Project name
- Project stage
- Tech stack summary
- Commands: build/dev/lint/typecheck/format/test
- Key paths summary

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

Rendering is handled by `template/.ados/render-ados.sh`.

## 4. Validate lean defaults
- Warn if `CLAUDE.md` exceeds 80 lines.
- Warn if `CLAUDE.md` imports `docs/backlog.md`.

## 5. Hand-off
Print next steps:
1. Fill first active backlog items.
2. Run `/project:session-start`.
3. Use `/project:session-end [lite|standard|full]` with risk-tier defaults.
4. Commit scaffold.
