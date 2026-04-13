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
- Foundation overview (short shared summary)
- Monorepo profile (auto-detected; workspace tool/scope)

This can run:
- interactively (`init-ados.sh`)
- non-interactively (flags to `init-ados.sh`)
- via Copier prompts (`copier.yml`)

## 3. Render placeholders
Replace placeholders in:
- `CLAUDE.md`
- `docs/NOW.md`
- `docs/TOPICS.md`
- `docs/foundation/overview.md`
- `docs/topics/bootstrap/INDEX.md`
- `docs/topics/bootstrap/cursor.md`
- `docs/topics/bootstrap/requirements.md`
- `docs/topics/bootstrap/plan.md`

Rendering is handled by `template/.ados/render-ados.sh`.

## 4. Validate lean defaults
- Warn if `CLAUDE.md` exceeds 80 lines.
- Warn if volatile docs are imported into `CLAUDE.md`.

## 5. Hand-off
Print next steps:
1. Fill `docs/foundation/overview.md`.
2. Review `docs/NOW.md`, `docs/TOPICS.md`, and the bootstrap pack.
3. Create the first real topic pack for the active seam.
4. Update `docs/NOW.md` and `docs/TOPICS.md` so the real pack becomes active.
5. Run `/project:session-start`.
6. Use `/project:session-end [lite|standard|full]` with risk-tier defaults.
7. Commit scaffold.
