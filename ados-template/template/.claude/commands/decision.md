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
- `docs/spec/business-rules.md` when the decision introduces, changes, or
  interprets a business rule
- `docs/spec/use-cases.md` when the decision changes canonical flow behavior
- memory `decisions.md` (if enabled)
