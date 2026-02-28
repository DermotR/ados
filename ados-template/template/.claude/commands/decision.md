# /project:decision [title]

Record durable decisions using ID format `D-YYYYMMDD-SNN-NN`.

Capture:
- Decision
- Context
- Rationale
- Alternatives rejected

Write to:
- `docs/.session-cursor.md` recent decisions (always)
- Current session log (`## Decisions`) when present
  - If running `lite` and no session log exists yet, create a minimal log entry
- memory `decisions.md` (if enabled)
