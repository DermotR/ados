# Foundation Overview

Last audited: 2026-04-13
If this file conflicts with repo state, follow the repo and update this file.

## Project Facts
- Name: ADOS
- Stage: v4 redesign and scaffold migration
- Stack: Markdown, Bash, Copier, Claude command/agent templates

## Shared Overview
ADOS is a metaproject for governed agentic development. This repository owns:

- the published process references (`ADOS-v2`, `v3`, `v4`)
- the project scaffold under `ados-template/`
- the init/smoke-test workflow for new ADOS-based repos

The current cross-pack priority is to keep the published v4 process, the scaffold,
and this repository's own docs aligned to the same pack-first model.

## Key Paths
- `ADOS-v4-PROCESS.md` - active process reference
- `ADOS-v4-MIGRATION.md` - migration guide for existing ADOS repos
- `ados-template/` - scaffold, initializer, and smoke tests
- `docs/topics/ados-v4-redesign/` - canon for the current redesign seam

## Shared Guardrails
- Root docs coordinate work; packs own seam requirements and plans.
- This repo should dogfood the same v4 structure it scaffolds.
- Process docs and template behavior must stay aligned.
- Keep `docs/foundation/` thin; seam-specific canon belongs in packs.
