# __PROJECT_NAME__

Last audited: __AUDIT_DATE__
If this file conflicts with repo state, follow the repo and update this file.

## Overview
This project is in __PROJECT_STAGE__. Use pack-first documentation and session protocol.

## Tech Stack
__TECH_STACK__

## Project Structure
__KEY_PATHS__

## Workspace Profile
- Monorepo mode: __MONOREPO_MODE__
- Workspace tool: __WORKSPACE_TOOL__
- Primary workspace scope: __WORKSPACE_SCOPE__

## Commands
- `__BUILD_CMD__`: Build
- `__DEV_CMD__`: Dev server
- `__LINT_CMD__`: Lint
- `__TYPECHECK_CMD__`: Type check
- `__FORMAT_CMD__`: Format check
- `__TEST_CMD__`: Test

## Commit Conventions
feat: | fix: | refactor: | docs: | test: | chore:

## Session Protocol
- Start: `/project:session-start`
- End: `/project:session-end [lite|standard|full]`
- Pack create: `/project:pack-create [topic-slug] [purpose]`
- Baseline: `/project:baseline-check [task summary]`
- Between tasks: `/clear`

## Core Rules
- Root docs coordinate work; topic packs own seam requirements and plans
- Read `docs/NOW.md` before implementation
- Read the active pack `INDEX.md` and `cursor.md` before code
- Promote cross-pack truths into `docs/foundation/`
- Evaluate before implementing: requirements -> scope -> dependencies -> test strategy
- Select close mode by risk; default to the lightest safe mode
- `standard` gates: `__LINT_CMD__ && __TYPECHECK_CMD__ && __FORMAT_CMD__`
- `full` gates: standard + full test suite (`__TEST_CMD__`)
- Decisions get IDs: D-YYYYMMDD-SNN-NN
- Session logs are the audit trail; update pack canon when decisions change it
- Work on feature branches, not main

## Engineering Preferences
- Explicit over clever
- DRY within modules; allow duplication across boundaries when coupling drops
- Prefer a test over none; choose the smallest test that proves behavior
- Run full suites at commit gate or when risk is broad
- Handle edge cases at boundaries; trust internals
- Multi-step work: confirm direction after first meaningful step

## Context Loading
- Read `docs/NOW.md`
- Read `docs/foundation/overview.md`
- Read the active pack `INDEX.md` and `cursor.md`
- Read pack `requirements.md` and `plan.md` as needed
- Read `docs/TOPICS.md` only when pack discovery/status is unclear
- Scan directories before opening many files

## References
@docs/foundation/overview.md
