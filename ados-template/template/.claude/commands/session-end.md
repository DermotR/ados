# /project:session-end

1. Run quality gates (lint, typecheck, format check).
2. Do review (subagent for large changesets).
3. Write session log (`docs/sessions/YYYY-MM-DD.md`).
4. Update `docs/backlog-active.md` (small active slice).
5. Update `docs/backlog.md` (full history/status).
6. Update `docs/.session-cursor.md`.
7. Update memory files if there are durable learnings.
8. Commit implementation, then docs.
