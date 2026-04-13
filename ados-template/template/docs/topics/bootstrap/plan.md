# Bootstrap Plan

## Current State

The v4 scaffold is in place, but it still needs project-specific shared context and a first real seam pack.

## Next Recommended Step

Fill `docs/foundation/overview.md`, then create the first real topic pack for the active seam before doing substantial implementation work.

## Work Chunks

### Chunk 1 - Confirm local workflow

- validate commands in `CLAUDE.md`
- confirm workspace scope and key paths
- confirm the close-mode workflow makes sense for this repo

### Chunk 2 - Fill shared overview

- replace placeholder project summary in `docs/foundation/overview.md`
- tighten key paths and workspace notes
- add only cross-pack truths here

### Chunk 3 - Create the first real topic pack

- choose the active seam
- create `docs/topics/<slug>/`
- add `INDEX.md`, `cursor.md`, `requirements.md`, and `plan.md`
- update `docs/NOW.md` and `docs/TOPICS.md` so the new pack becomes active

Recommended path:

- run `/project:pack-create [topic-slug] [purpose]`
- then review and tighten the generated files before substantial implementation starts

### Chunk 4 - Demote bootstrap

- move bootstrap out of the active path once the real pack exists
- keep only the minimal historical/setup value

## Checklist

- [ ] Commands in `CLAUDE.md` are valid for this repo
- [ ] `docs/foundation/overview.md` reflects the real project
- [ ] First real topic pack is created
- [ ] `docs/NOW.md` points to the real active pack
- [ ] `docs/TOPICS.md` reflects the new active/reference state

## Open Implementation Questions

- should this project add `docs/foundation/architecture.md` immediately, or only after a second pack needs it?
