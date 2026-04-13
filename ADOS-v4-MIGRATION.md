# ADOS v4 Migration Guide

Use this guide when migrating an existing ADOS repo from v3-style backlog/spec/planning docs to the v4 pack-first model.

## Core Shift

Move from document-type buckets to seam-owned packs:

- root docs coordinate work
- topic packs own seam requirements and plans
- session logs remain the audit trail

## New Baseline

Add:

- `docs/NOW.md`
- `docs/TOPICS.md`
- `docs/foundation/overview.md`
- `docs/topics/<slug>/`

Remove or absorb:

- `docs/backlog-active.md`
- `docs/backlog.md`
- `docs/context/`
- `docs/planning/`
- `docs/packets/`
- most of `docs/spec/`

## Migration Steps

1. Create the new root control docs.
2. Create the first real topic pack for active work.
3. Split the old cursor into:
   - `NOW.md` for immediate handoff
   - pack `cursor.md` for seam-local handoff
4. Move seam requirements and rules into pack `requirements.md`.
5. Move seam sequencing and checklists into pack `plan.md`.
6. Promote only genuinely cross-pack truths into `docs/foundation/overview.md`.
7. Update `CLAUDE.md`, session commands, and hooks to use the new read/write flow.
8. Delete obsolete v3 structures after one real session proves the new model works.

## Mapping Table

| v3 artifact | v4 destination |
|---|---|
| `docs/.session-cursor.md` | `docs/NOW.md` + pack `cursor.md` |
| `docs/backlog-active.md` | removed |
| `docs/backlog.md` | removed |
| `docs/context/core.md` | `CLAUDE.md` + `docs/foundation/overview.md` |
| `docs/context/pack-*.md` | pack docs |
| `docs/planning/*` | pack `plan.md` |
| `docs/packets/*` | pack `plan.md` or `references/` |
| `docs/spec/*` | pack `requirements.md` unless cross-pack |

## Failure Modes To Avoid

- `NOW.md` turning into backlog by another name
- `docs/foundation/` turning into a second global spec tree
- keeping both old and new canon alive in parallel
- making packs so heavy that the old sprawl simply reappears inside folders

For the fuller redesign context, see [ADOS-v4-PROCESS.md](/Users/dermot/code/agentic-coding-operating-system/ADOS-v4-PROCESS.md:1) and the active redesign pack at [docs/topics/ados-v4-redesign/INDEX.md](/Users/dermot/code/agentic-coding-operating-system/docs/topics/ados-v4-redesign/INDEX.md:1).
