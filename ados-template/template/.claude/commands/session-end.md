# /project:session-end

Close mode: `lite | standard | full` (auto-infer unless user specifies).

Classifier:
- `lite`: <=3 files, no schema/API/auth/payment/security/core-infra changes, no new abstraction.
- `standard`: default mode for normal feature work.
- `full`: >8 files, or cross-cutting/contract/security/migration/release-critical changes.

1. Determine close mode and state why.
2. Run checks by mode:
   - `lite`: targeted checks proving changed behavior.
   - `standard`: lint + typecheck + format check.
   - `full`: standard checks + full test suite (+ integration/e2e if relevant).
3. Run review by mode:
   - `lite`: quick self-review.
   - `standard`: self-review; subagent if >5 files/new abstractions.
   - `full`: code-reviewer subagent required.
4. Always update:
   - `docs/backlog-active.md`
   - `docs/.session-cursor.md`
5. `standard|full`: write `docs/sessions/YYYY-MM-DD.md`.
6. `lite` + decision IDs recorded: create a minimal session log for auditability.
7. `full` (or material status/history change): update `docs/backlog.md`.
8. Write memory only if durable reusable learnings emerged.
9. Update diagrams only when structural changes occurred.
10. Commit and report mode/checks/docs/next handoff.
