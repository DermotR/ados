# /project:session-end

Close mode: `lite | standard | full` (auto-infer unless user specifies).

Classifier:
- `lite`: <=3 files, no schema/API/auth/payment/security/core-infra changes, no new abstraction.
- `standard`: default mode for normal feature work.
- `full`: >8 files, or cross-cutting/contract/security/migration/release-critical changes.
- Escalate at least to `standard` for cross-workspace/package changes in monorepos.

1. Determine close mode and state why.
2. Run checks by mode:
   - `lite`: targeted checks proving changed behavior.
   - `standard`: lint + typecheck + format check.
   - `full`: standard checks + full test suite (+ integration/e2e if relevant).
3. Run review by mode:
   - `lite`: quick self-review.
   - `standard`: self-review; subagent if >5 files/new abstractions.
   - `full`: code-reviewer subagent required.
4. Always update the active pack `cursor.md`.
5. Update the active pack `plan.md` when progress, sequencing, or open questions changed.
6. Update the active pack `requirements.md` when canon changed.
7. Update `docs/NOW.md` only if current focus or immediate handoff changed.
8. Update `docs/TOPICS.md` only if pack status changed.
9. `standard|full`: write `docs/sessions/YYYY-MM-DD.md`.
10. `lite` + decision IDs recorded: create a minimal session log for auditability.
11. Write memory only if durable reusable learnings emerged.
12. Update pack-local diagrams or `docs/foundation/diagrams/` only when structural changes occurred.
13. Commit and report mode/checks/docs/next handoff.
