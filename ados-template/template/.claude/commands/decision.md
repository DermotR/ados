# /project:decision [title]

Record durable decisions using ID format `D-YYYYMMDD-SNN-NN`.

Capture:
- Decision
- Context
- Rationale
- Alternatives rejected

Write to:
- current session log (`## Decisions`) when present
  - if running `lite` and no session log exists yet, create a minimal log entry
- active pack `requirements.md` and/or `plan.md` when the decision changes seam canon
- `docs/foundation/overview.md` or `docs/foundation/architecture.md` only when
  the decision changes shared cross-pack truth
- `docs/NOW.md` only if the decision changes the immediate handoff
- memory `decisions.md` (if enabled)
