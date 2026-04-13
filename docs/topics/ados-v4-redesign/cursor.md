# ADOS v4 Redesign - Cursor

Last updated: 2026-04-13
Volatile handoff - rewrite often.

## Current Status

The v4 redesign is materially landed:

- `ADOS-v4-PROCESS.md` exists
- the scaffold is pack-first
- `init-ados.sh` and smoke tests are updated
- copier validation now passes
- this repo now has v4 root control docs and a real redesign pack

## What Was Locked

- topic packs are canon for requirements and planning
- root docs are a control plane, not a second source of truth
- backlog is removed for now
- `docs/foundation/overview.md` is the only required foundation file by default
- diagrams are pack-local unless they are truly cross-pack/system-level

## Next Step

1. Review the final diff.
2. Decide whether `TMP-ADOS-V4-PLAN.md` should be kept as a temporary alias or retired.
3. Commit the v4 migration.

## Warnings

- do not let the temp plan file become a second source of truth
- do not add new root docs when the pack already owns the seam
