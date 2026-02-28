# __PROJECT_NAME__

Last audited: __AUDIT_DATE__
If this file conflicts with repo state, follow the repo and update this file.

## Overview
This project is in __PROJECT_STAGE__. Keep implementation aligned with backlog IDs and session protocol.

## Tech Stack
__TECH_STACK__

## Project Structure
__KEY_PATHS__

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
- Baseline: `/project:baseline-check [task summary]`
- Between tasks: `/clear`

## Core Rules
- Backlog-first: never start work without active backlog IDs
- Load `docs/backlog-active.md` before `docs/backlog.md`
- Evaluate before implementing: spec -> scope -> dependencies -> test strategy
- Select close mode by risk; default to the lightest safe mode
- `standard` gates: `__LINT_CMD__ && __TYPECHECK_CMD__ && __FORMAT_CMD__`
- `full` gates: standard + full test suite (`__TEST_CMD__`)
- Decisions get IDs: D-YYYYMMDD-SNN-NN
- Work on feature branches, not main
- No net growth for always-loaded rules (add one, remove/shrink one)

## Engineering Preferences
- Explicit over clever
- DRY within modules; allow duplication across boundaries when coupling drops
- Prefer a test over none; choose the smallest test that proves behavior
- Run full suites at commit gate or when risk is broad
- Handle edge cases at boundaries; trust internals
- Multi-step work: confirm direction after first meaningful step

## Context Loading
- Read `docs/.session-cursor.md`
- Read `docs/context/core.md`
- Read `docs/backlog-active.md`
- Open `docs/backlog.md` only if active slice is insufficient
- Scan directories before opening many files

## References
@docs/context/core.md
