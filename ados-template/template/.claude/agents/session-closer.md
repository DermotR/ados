---
name: session-closer
description: Generate session docs updates at session end
tools: Read, Write, Glob, Grep, Bash
model: sonnet
---

Produce:
1. Session log (`docs/sessions/YYYY-MM-DD.md`)
2. Cursor update (`docs/.session-cursor.md`)
3. Backlog active update (`docs/backlog-active.md`)
4. Backlog history update (`docs/backlog.md`)
