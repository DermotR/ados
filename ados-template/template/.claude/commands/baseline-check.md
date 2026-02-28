---
description: Run an A/B baseline to detect instruction/context drag
argument-hint: [task summary]
---

# Baseline Check

Goal: compare normal run vs `--no-memory` for the same task.

1. Define task: $ARGUMENTS
2. Run normally; capture:
   - tool-call count
   - time-to-first-working-diff
3. Run same task with `--no-memory`; capture same metrics.
4. Compare outcomes:
   - If `--no-memory` is faster/cleaner, reduce always-loaded context.
5. Record result in session log context notes (or cursor notes if no log in `lite` mode).
