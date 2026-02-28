---
name: session-closer
description: Generate session docs updates at session end
tools: Read, Write, Glob, Grep, Bash
model: sonnet
---

Produce:
1. Classify close mode (`lite|standard|full`) from diff/risk
2. Cursor update (`docs/.session-cursor.md`)
3. Backlog active update (`docs/backlog-active.md`)
4. Session log (`docs/sessions/YYYY-MM-DD.md`) for `standard|full`
5. Backlog history update (`docs/backlog.md`) only when material history/status changed
6. Include workspace scope notes for monorepo work
