# ADOS v4 Redesign

Purpose: canonical pack for the pack-first redesign of ADOS itself. This pack owns the v4 documentation model, scaffold migration, self-dogfooding in this repo, and migration guidance for existing ADOS repos.

## Scope

In scope:

- v4 file model and ownership rules
- v4 process reference
- scaffold/template/command/script alignment
- migration guidance from v3 to v4
- this repo's own migration into `NOW` / `TOPICS` / `foundation` / topic packs

Out of scope:

- new product features unrelated to the v4 model
- restoring backlog as a first-class concept
- keeping v3 categories alive for compatibility if they no longer fit

## Read Order

1. `cursor.md`
2. `requirements.md`
3. `solution.md`
4. `plan.md`
5. `references/migrating-existing-ados-repos.md`

## File Guide

- `cursor.md`: volatile handoff for the redesign seam
- `requirements.md`: why v4 exists and what it must preserve or remove
- `solution.md`: the v4 doc model, ownership rules, and operating defaults
- `plan.md`: execution status and checklist for the redesign
- `references/migrating-existing-ados-repos.md`: practical migration steps for v3 repos

## Related Docs

- `../../../ADOS-v4-PROCESS.md`
- `../../../ADOS-v4-MIGRATION.md`
- `../../NOW.md`
- `../../TOPICS.md`
- `../../foundation/overview.md`

## Current Stance

The v4 reference, scaffold, init path, smoke tests, and copier path are landed.
The main remaining action in this seam is review and commit hygiene, plus deciding
when to retire the temporary working-plan file.
