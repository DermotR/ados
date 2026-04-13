# Migrating Existing ADOS Repos

## Goal

Move a v3-style ADOS repo to v4 without recreating backlog/spec/planning sprawl under new names.

## Recommended Order

1. Add the new root control docs:
   - `docs/NOW.md`
   - `docs/TOPICS.md`
   - `docs/foundation/overview.md`
2. Identify the first real seam and create its pack:
   - `docs/topics/<slug>/INDEX.md`
   - `cursor.md`
   - `requirements.md`
   - `plan.md`
3. Split the old cursor:
   - immediate handoff -> `docs/NOW.md`
   - seam-specific handoff -> pack `cursor.md`
4. Move canon:
   - seam requirements and rules -> pack `requirements.md`
   - seam sequencing and checklist -> pack `plan.md`
   - cross-pack truths only -> `docs/foundation/overview.md`
5. Update `CLAUDE.md` and command docs to load `NOW.md` plus active packs.
6. Delete obsolete v3 structures:
   - `docs/backlog-active.md`
   - `docs/backlog.md`
   - `docs/context/`
   - `docs/planning/`
   - `docs/packets/`
   - `docs/spec/` except material explicitly promoted elsewhere
7. Run at least one real session using the new docs before cleaning up the old files completely.

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

## Heuristics

- If a truth only matters to one seam, keep it in that pack.
- If more than one pack needs it, promote it into `docs/foundation/`.
- If `NOW.md` starts tracking a queue, you recreated backlog.
- If a pack needs multiple independent read paths, split it.

## Minimum Success Criteria

- a normal session starts from `CLAUDE.md`, `docs/NOW.md`, and one pack
- there is no backlog file left behind
- there is no second global spec tree
- requirements and planning canon are obvious
