# Solution

## v4 Doc Model

The redesign adopts a hybrid:

- thin root control docs
- pack-local seam canon
- global session logs
- minimal shared foundation docs

Default root set:

- `docs/NOW.md`
- `docs/TOPICS.md`
- `docs/foundation/overview.md`
- `docs/sessions/`
- `docs/archive/`

Default pack set:

- `INDEX.md`
- `cursor.md`
- `requirements.md`
- `plan.md`

Optional pack files:

- `solution.md`
- `manual.md`
- `references/`
- pack-local diagrams

## Ownership Model

- `NOW.md`: immediate handoff only
- `TOPICS.md`: pack discovery and status only
- `foundation/`: only cross-pack truths
- pack `requirements.md`: canonical seam requirements
- pack `plan.md`: canonical seam sequencing and checklist
- pack `cursor.md`: volatile handoff only
- session logs: chronology and audit

## Session Defaults

Session start should usually read:

1. `CLAUDE.md`
2. `docs/NOW.md`
3. active pack `INDEX.md`
4. active pack `cursor.md`
5. pack `requirements.md` / `plan.md` as needed

Session end should usually update:

1. active pack `cursor.md`
2. active pack `plan.md` if progress changed
3. active pack `requirements.md` if canon changed
4. `docs/NOW.md` only if immediate handoff changed
5. session log when justified by scope or mode

## Migration Direction

High-level mapping:

- `.session-cursor` -> `NOW.md` + pack `cursor.md`
- `backlog*` -> removed
- `context/core` -> `CLAUDE.md` + `foundation/overview.md`
- `planning/*` -> pack `plan.md`
- `packets/*` -> absorb into pack `plan.md` or `references/`
- `spec/*` -> pack canon unless genuinely cross-pack

## Dogfooding Rule

This repository should use the same v4 model it publishes and scaffolds. If the
repo itself keeps working from temporary or parallel structures, the redesign is
not complete.
