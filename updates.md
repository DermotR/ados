## ADOS v2 Quick Wins Directive (instructions for the process-design agent)

**Goal:** reduce “always-loaded” context bloat + staleness risk, while keeping ADOS’s continuity and quality discipline.

### 1) Budget `@imports` like dependencies (tiny + stable only)

**Instruction:** Remove any `@import` that can grow or changes frequently (backlogs, large “core” docs, big packs). Only import small, stable files.

**Rationale:** Imported files are *guaranteed context injection* every session; bigger / noisier imports raise cost and can distract the model before it even starts the task.

**Apply changes:**

* Update the **root `CLAUDE.md` template** to import only the smallest stable “core” (if any).
* Replace `@docs/backlog.md` with a **pointer**: “Backlog lives at `docs/backlog.md` (open only when needed).”
* Update `/project:session-start` to open `docs/backlog-active.md` (see next item), not the full backlog.

---

### 2) Split backlog into `backlog-active.md` (always small) + full `backlog.md` (archive)

**Instruction:** Create `docs/backlog-active.md` that contains only the current milestone + 3–10 active items (IDs + acceptance criteria). Keep `docs/backlog.md` as the full archive/history.

**Rationale:** Backlogs are high-churn and grow fast. Loading them routinely is classic “token bloat” with low signal.

**Apply changes:**

* Add to File Map: `docs/backlog-active.md`.
* Update `/project:session-start` to read:

  * `docs/.session-cursor.md`
  * `docs/context/core.md`
  * `docs/backlog-active.md`
  * (Open `docs/backlog.md` only if the active slice is insufficient.)

---

### 3) Add `Last audited` headers + “repo is source of truth” behavior

**Instruction:** Add a `Last audited: YYYY-MM-DD` line to every always-loaded doc, plus a one-line rule: if it conflicts with the repo, follow the repo and propose updating the doc.

**Rationale:** Stale guidance is worse than no guidance because it contaminates every prompt.

**Apply changes (minimum):**

* Root `CLAUDE.md`
* `docs/.session-cursor.md`
* `docs/context/core.md`
* `MEMORY.md` (top section)

---

### 4) Make engineering preferences “incident-driven” (tighten, don’t accrete)

**Instruction:** Keep only preferences that prevent recurring agent failure modes. If a rule isn’t actively preventing mistakes, move it out of always-loaded context (e.g., `CLAUDE.local.md` or a non-loaded reference doc).

**Rationale:** Always-on rules become noise; noise reduces accuracy and increases wandering.

**Apply changes:**

* Add a maintenance rule: **“No net growth”** — adding a new always-loaded rule requires removing or shrinking another.
* Reword the testing preference away from “more is always better” (see #5).

---

### 5) Replace “over-testing” bias with “smallest test that proves it”

**Instruction:** Update the default testing posture to: write the smallest targeted test that validates the change; run full suites only at quality gates or when signals suggest broad impact.

**Rationale:** Hard “do more tests” guidance can force unnecessary work and reduce completion rates on tight tasks.

**Apply changes:**

* In `CLAUDE.md` Engineering Preferences, replace:

  * “Prefer over-testing to under-testing”
  * with:
  * **“Prefer a test over none, but choose the smallest test that proves the behavior. Run full suites at commit gate or when risk is broad.”**

---

### 6) Add a “baseline run” protocol using `--no-memory`

**Instruction:** When a task feels slow, distracted, or over-procedural, run a quick A/B baseline using `--no-memory` to see whether always-loaded instructions are hurting.

**Rationale:** This gives repo-specific evidence; it prevents arguing from vibes and catches instruction drag early.

**Apply changes:**

* Add a short `.claude/commands/baseline-check.md` that instructs:

  * Run task normally (capture: tool calls count, time-to-first-working-diff)
  * Run again with `--no-memory`
  * If baseline wins: reduce imports / shrink always-loaded docs / move content to on-demand packs.

---

### 7) Treat `MEMORY.md` top 200 lines as “pinned context” (strict)

**Instruction:** Keep the first 200 lines of `MEMORY.md` ultra-lean: **facts, commands, sharp gotchas only**. Everything else goes into topic files (`patterns.md`, `debugging.md`, etc.) and is loaded on demand.

**Rationale:** Auto-memory is still context injection. If it becomes a dumping ground, you recreate the same failure mode as bloated `CLAUDE.md`.

**Apply changes:**

* Add policy at top of `MEMORY.md`:

  * “Top 200 lines only = pinned essentials.”
  * “Move detail to topic files; never exceed the cap.”

---

### Output expected from the agent

1. A patch updating ADOS docs/templates to reflect items 1–7
2. New `docs/backlog-active.md` template
3. Updated root `CLAUDE.md` example (imports reduced; backlog pointer; refined testing line)
4. New `.claude/commands/baseline-check.md` (short, actionable)

If you want, paste your current `CLAUDE.md` template and I’ll rewrite it to match these quick wins verbatim.
