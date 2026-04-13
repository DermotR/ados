---
name: session-closer
description: Generate session docs updates at session end
tools: Read, Write, Glob, Grep, Bash
model: sonnet
---

Produce:
1. Classify close mode (`lite|standard|full`) from diff/risk
2. Active pack cursor update (`docs/topics/<slug>/cursor.md`)
3. Active pack plan update when progress or sequencing changed
4. Active pack requirements update when canon changed
5. `docs/NOW.md` update only when focus or immediate handoff changed
6. `docs/TOPICS.md` update only when pack status changed
7. Session log (`docs/sessions/YYYY-MM-DD.md`) for `standard|full`
8. Include workspace scope notes for monorepo work
9. When structure changed, update pack-local diagrams or `docs/foundation/diagrams/`
