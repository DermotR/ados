# Plan

## Current State

The major v4 migration work is done:

- process reference written
- scaffold file structure rewritten
- template commands/hooks/agents updated
- init script updated
- smoke tests updated
- copier path validated
- this repo migrated onto the v4 `docs/` shape
- migration guide written

## Next Recommended Step

Review the final diff, decide what to do with `TMP-ADOS-V4-PLAN.md`, and commit
the migration.

## Work Chunks

### Chunk 1 - Define v4

- lock the file map
- lock ownership rules
- lock session defaults

Status: done

### Chunk 2 - Rewrite published process and scaffold

- add `ADOS-v4-PROCESS.md`
- rewrite template docs and commands
- remove v3 backlog/spec/planning assumptions

Status: done

### Chunk 3 - Validate automation

- update init flow
- update smoke tests
- validate copier path

Status: done

### Chunk 4 - Dogfood in this repo

- create `docs/NOW.md`
- create `docs/TOPICS.md`
- create `docs/foundation/overview.md`
- create a real redesign pack

Status: done

### Chunk 5 - Finish out

- review final repo diff
- decide whether to keep or retire the temp plan file
- commit

Status: active

## Checklist

- [x] Write `ADOS-v4-PROCESS.md`
- [x] Rewrite the scaffold file structure
- [x] Rewrite template commands, hooks, and agents
- [x] Rewrite `init-ados.sh`
- [x] Rewrite smoke tests
- [x] Validate copier path
- [x] Dogfood v4 docs in this repo
- [x] Write a migration guide for existing ADOS repos
- [ ] Decide the fate of `TMP-ADOS-V4-PLAN.md`
- [ ] Commit the migration

## Open Implementation Questions

- should `TMP-ADOS-V4-PLAN.md` be kept until after the first commit, then removed?
- should the migration guide stay at repo root, or eventually move behind a shorter root pointer?
