# Agentic Development Operating System (ADOS) v3

## Process Reference

---

## 1. What ADOS Is

ADOS is the operational layer between a raw AI coding agent and productive
project work. It governs how sessions start, run, and close. It ensures
continuity across stateless sessions, enforces quality and engineering
standards, and maintains a living audit trail of decisions and progress.

ADOS is not a project management tool, a CI/CD system, or a code quality
framework. It is the protocol that makes agentic development reliable and
repeatable.

### 1.1 The Eight Concerns

| # | Concern | What it covers |
|---|---------|----------------|
| 1 | Session Lifecycle | Start, curate, close protocols; hooks; slash commands |
| 2 | Knowledge Persistence | Session cursor, auto memory, session logs, carry-forward notes |
| 3 | Work Governance | CLAUDE.md standards, engineering preferences, context discipline, quality gates |
| 4 | Planning & Backlog | Backlog structure, implementation plans, session mapping, milestones, task packets |
| 5 | Requirements & Decisions | Business rules, decision records, spec references |
| 6 | Context Engineering | Topic packs, @imports, `/clear` discipline, compaction strategy |
| 7 | Agent Orchestration | Subagent roles, tool restrictions, delegation patterns, review workflow |
| 8 | Quality Assurance | Gates, code review (scoped), visual QA, diagram sync |

### 1.2 The Core Loop

```
Read cursor → Select work → Load context → Evaluate → Implement → Review → Log → Update cursor
     ↑                                                                                  │
     └──────────────────────── SESSION BOUNDARY (stateless reset) ──────────────────────┘
```

### 1.3 Companion Documents

| Document | Purpose |
|----------|---------|
| `ADOS-INIT.md` | Bootstrap instructions for new projects |
| `ADOS-UPGRADE-DIRECTIVE.md` | Migration guide from v2 to v3 |
| `ADOS-TEST-FRAMEWORK.md` | Protocol conformance testing harness |
| `ados-system-diagram.mermaid` | Visual reference of the full system |

---

## 2. File Map

```
CLAUDE.md                                    # Constitution (≤80 lines, @imports)
CLAUDE.local.md                              # Personal preferences (gitignored)

.claude/
├── commands/
│   ├── session-start.md                     # Start protocol (slash command)
│   ├── session-end.md                       # Close protocol (slash command)
│   ├── decision.md                          # Record a decision
│   ├── task-packet.md                       # Generate task breakdown
│   └── baseline-check.md                    # A/B check for instruction drag (`--no-memory`)
├── agents/
│   ├── session-closer.md                    # Generates logs, updates cursor
│   ├── code-reviewer.md                     # Pre-commit review (read-only)
│   └── diagram-syncer.md                    # Keeps diagrams in sync with code
├── hooks/
│   ├── session-start.sh                     # Environment checks on init
│   ├── stop-validate.sh                     # Warns if docs not updated
│   └── pre-compact.sh                       # Backs up transcript before compaction
└── settings.json                            # Tool permissions + hook registration

docs/
├── .session-cursor.md                       # Mutable handoff state
├── backlog-active.md                        # Small active slice (current milestone + 3-10 items)
├── backlog.md                               # Product backlog
├── context/
│   ├── core.md                              # Always-loaded project context
│   ├── pack-db.md                           # Database context pack
│   ├── pack-api.md                          # API context pack
│   ├── pack-ui.md                           # UI context pack
│   └── pack-{domain}.md                     # Additional domain packs
├── planning/
│   ├── IMPLEMENTATION-PLAN-TEMPLATE.md
│   └── IMP-YYYY-MM-DD-slug.md              # Actual plans
├── sessions/
│   ├── SESSION-TEMPLATE.md
│   └── YYYY-MM-DD.md                        # Session logs (keep last 5 active)
├── packets/
│   └── {PROJECT}-NNN.md                     # Task breakdowns
├── diagrams/
│   └── *.puml                               # PlantUML diagrams
├── spec/                                    # Product specification
└── archive/
    ├── README.md                            # Archive policy
    ├── sessions/M{N}/                       # Rotated session logs per milestone
    └── ados-v{N}/                           # CLAUDE.md version snapshots

packages/*/CLAUDE.md                         # Directory-level rules (monorepos)
apps/**/CLAUDE.md                            # Path-scoped rules

~/.claude/projects/<project>/memory/         # Auto memory (per-machine, not git-tracked)
├── MEMORY.md                                # Pinned essentials only (top 200 lines auto-loaded)
├── decisions.md                             # Recent decisions (agent-discoverable)
├── patterns.md                              # Code patterns discovered
└── debugging.md                             # What worked when things broke
```

---

## 3. CLAUDE.md — The Constitution

CLAUDE.md is the root instruction file. Claude Code reads it automatically
at session start. It must be lean — under 80 lines — because frontier models
reliably follow ~150-200 instructions and Claude Code's system prompt already
consumes ~50 of those slots.

### 3.1 What belongs in CLAUDE.md

- Project overview (what, who, stage)
- Tech stack summary
- Project structure map
- Essential commands (build, dev, lint, typecheck, format, test)
- Commit conventions
- Session protocol summary (pointers to slash commands)
- Core rules (universal, every-session rules)
- Engineering preferences
- Context loading instructions
- Minimal @import references (tiny + stable only)

### 3.2 What does NOT belong in CLAUDE.md

| Instead of... | Put it in... |
|---------------|-------------|
| Domain-specific code rules | Directory-level CLAUDE.md (`packages/db/CLAUDE.md`) |
| Session start/end checklists | Slash commands (`.claude/commands/`) |
| Style rules the linter enforces | Nowhere — let the linter handle it |
| File-by-file code explanations | Context packs (`docs/context/pack-*.md`) |
| Session state | Session cursor (`docs/.session-cursor.md`) |

### 3.3 Engineering Preferences Block

Include in CLAUDE.md under Core Rules. These prevent per-session re-negotiation
of engineering philosophy:

```markdown
## Engineering Preferences
- Explicit over clever — boring, obvious code wins
- DRY within a module; tolerate duplication across boundaries when it reduces coupling
- Prefer a test over none, but choose the smallest test that proves the behavior.
  Run full suites at commit gate or when risk is broad.
- Handle edge cases at boundaries (API inputs, user inputs); trust internals
- "Engineered enough" = handles known requirements + obvious edge cases,
  no speculative abstraction
- When uncertain between two approaches: present options, don't pick silently
- For multi-step work: confirm direction with the user after the first meaningful
  step before building on assumptions
```

These are ~10 lines and cheap in context. They shape every implementation
decision the agent makes.

### 3.4 @import Mechanism

CLAUDE.md can reference external files:

```markdown
@docs/context/core.md
```

Budget imports like dependencies: only import tiny, stable documents. Do not
import high-churn files (backlogs, large packs, mutable logs). Keep imports to
minimal core context; open other docs on demand.

Backlog pointer rule for CLAUDE.md: "Backlog lives at `docs/backlog.md` (open
only when needed; use `docs/backlog-active.md` first)."

### 3.5 Directory-Level CLAUDE.md Files

Claude Code natively loads CLAUDE.md from child directories when it works in
those directories. Use this for path-scoped rules:

```
packages/db/CLAUDE.md          # 20-40 lines: Prisma conventions, migration rules
packages/ui/CLAUDE.md          # 20-40 lines: component patterns, design tokens
apps/web/src/app/api/CLAUDE.md # 20-40 lines: route conventions, validation
```

These load on demand — they cost nothing when the agent is working elsewhere.

### 3.6 Evolution Rules

- When Claude consistently gets something wrong → add a rule
- When a rule is never triggered → remove it
- Keep rules incident-driven: include only rules that prevent recurring failures
- No net growth: adding an always-loaded rule requires removing or shrinking another
- Never send an LLM to do a linter's job
- Review CLAUDE.md quarterly; snapshot before major changes to `docs/archive/`
- Prefer pointers (`see path/to/file`) over copies (code snippets that go stale)

---

## 4. Session Lifecycle

### 4.1 Session Start Protocol

Triggered by: `/project:session-start`

```
Step 1: READ CURSOR
  Read docs/.session-cursor.md
  → What session is next, what work is planned, what packs to load,
    any handover notes or blockers

Step 2: CHECK ENVIRONMENT
  git status          → flag uncommitted changes
  git branch          → confirm correct branch (not main)
  dependency check    → Docker/services if applicable

Step 3: LOAD CONTEXT PACKS
  Read docs/context/core.md (always)
  Read docs/backlog-active.md (always, keep small)
  Read cursor-specified packs only
  Open docs/backlog.md only if active slice is insufficient
  Report what was loaded and estimated context usage

Step 4: VERIFY CODEBASE (conditional)
  If resuming after >24h, after pulls, or after dependency changes:
    Run lint + typecheck to confirm clean state

Step 5: EVALUATE BEFORE IMPLEMENTING
  For ALL work:
    a. Spec alignment — does the task match requirements? Flag drift.
    b. Scope check — UI-only, backend-only, or cross-cutting?
    c. Dependencies — are prerequisite sessions complete?
    d. Test strategy — what tests will verify this? Note them.

  For NON-TRIVIAL work (multiple files, new abstractions, architectural impact):
    e. Present 2-3 approach options. For each option:
       - What it involves (concrete file/line references where possible)
       - Effort estimate (small / medium / large)
       - Risk and downstream impact
       - Maintenance burden
    f. Include "do nothing" or "minimal change" where reasonable
    g. Recommend one option with rationale
    h. WAIT for user confirmation before proceeding

  For SMALL, WELL-DEFINED work:
    State the approach briefly and proceed unless the user objects.

Step 6: PRESENT PLAN
  Summarise:
    - Session N: {title}
    - Backlog IDs: {list}
    - Packs loaded: {list}
    - Approach: {chosen or proposed}
    - Steps: {numbered plan}
  Await user confirmation before coding.
```

### 4.2 Session Execution

During implementation, these rules apply:

**Backlog-first discipline**
Never start work without active backlog IDs. If the user requests something
not on the backlog, flag it and ask whether to create a backlog item or defer.

**Decision recording**
When a significant choice is made (technology, approach, rejected alternatives):
- Record immediately using `/project:decision [title]`
- Format: `D-YYYYMMDD-SNN-NN` (date, session number, sequence)
- Captured in: session log (authoritative) + cursor (cross-session) + auto memory (discoverable)

**Confirm-before-continuing**
For multi-step work: confirm direction with the user after completing the first
meaningful step. Do not build steps 2-5 on assumptions that step 1 validated.
This prevents wasted work on directions the user would veto.

**Context hygiene**
- `/clear` between distinct tasks within a session
- If context exceeds ~60%: summarise findings into auto memory, `/clear`, continue
- Before heavy file-read operations: check context pressure
- When a long exploratory sequence completes: summarise, compress, continue

**Commit discipline**
- Work on feature branches, never directly on main
- Conventional commits: `feat:` | `fix:` | `refactor:` | `docs:` | `test:` | `chore:`
- Small, atomic commits with clear messages
- Run checks appropriate to close mode before commit (see §8)
- Never force-push without explicit user approval

### 4.3 Session Close Protocol (Risk-Tiered)

Triggered by: `/project:session-end [lite|standard|full]`

Uses `context: fork` when close work needs broad file reads. Keep the main
implementation context clean.

```
Step 0: CLASSIFY CLOSE MODE
  Infer from `git diff --stat` + change type, unless user explicitly selects:

  lite:
    - <=3 files changed
    - no schema/API contract/auth/payment/security/core infra changes
    - no new abstraction/pattern introduction

  standard:
    - default for normal feature work
    - medium scope, bounded risk, no release-critical surfaces

  full:
    - >8 files, or cross-cutting architecture changes
    - schema migrations, external contract changes, auth/payment/security
    - pre-release/pre-merge hardening or explicit user request

Step 1: RUN MODE-SCOPED QUALITY CHECKS
  lite:
    - run smallest targeted checks proving changed behavior
    - run full lint/typecheck/format only if signals indicate broad impact

  standard:
    - run lint + typecheck + format check

  full:
    - run lint + typecheck + format check + full test suite
    - add targeted integration/e2e checks when relevant

Step 2: RUN MODE-SCOPED REVIEW
  lite:
    - quick self-review (single highest-impact issue per dimension)

  standard:
    - self-review; invoke code-reviewer if >5 files or new abstractions

  full:
    - invoke code-reviewer subagent
    - address BLOCK verdicts before commit

Step 3: WRITE DOCUMENTATION (MINIMUM BY MODE)
  Always:
    - update docs/backlog-active.md
    - update docs/.session-cursor.md

  standard/full:
    - create or update docs/sessions/YYYY-MM-DD.md (concise)

  lite with decision records:
    - create a minimal session log entry for decision auditability

  full:
    - update docs/backlog.md if status/history changed materially
    - update diagrams when structure changed

Step 4: OPTIONAL KNOWLEDGE WRITES (TRIGGERED ONLY)
  Write to auto memory only when durable, reusable learnings emerged:
    - debugging method that repeatedly works
    - architecture/pattern insight likely to recur
  Otherwise skip.

Step 5: COMMIT
  Stage and commit:
    - implementation commit(s) first
    - docs commit when docs changed

Step 6: REPORT
  Present to user:
    - mode used (lite/standard/full) and why
    - checks run
    - docs updated
    - remaining risks / next session handoff
```

Principle: default to the lightest safe close mode. Escalate only when change
risk justifies heavier process.

### 4.4 Hooks (Automated Enforcement)

Hooks make parts of the protocol structural rather than relying on the agent
to remember checklists.

| Hook | Trigger | Purpose |
|------|---------|---------|
| `session-start.sh` | SessionStart | Warn about uncommitted changes, wrong branch |
| `stop-validate.sh` | Stop | Warn if close artifacts are missing (cursor and/or session log) |
| `pre-compact.sh` | PreCompact | Back up transcript before compaction |

Hooks are registered in `.claude/settings.json`. They warn by default;
set exit code 2 to block (use sparingly — blocking the agent is disruptive).

---

## 5. Knowledge Persistence

### 5.1 The Persistence Model

| What | Where | Maintained by | Git-tracked? | Loaded when? |
|------|-------|---------------|-------------|-------------|
| Session handoff state | `docs/.session-cursor.md` | Session-end protocol | Yes | Every session start |
| Audit trail | `docs/sessions/YYYY-MM-DD.md` | Session-end protocol | Yes | On demand (prior session review) |
| Decisions (authoritative) | Session logs + cursor | /decision command | Yes | Cursor at start; logs on demand |
| Decisions (discoverable) | `memory/decisions.md` | Agent (auto memory) | No | Auto-loaded (first 200 lines of MEMORY.md) |
| Patterns & learnings | `memory/patterns.md` | Agent (auto memory) | No | On demand |
| Debugging knowledge | `memory/debugging.md` | Agent (auto memory) | No | On demand |
| Active work queue | `docs/backlog-active.md` | Session-end protocol | Yes | Every session start |
| Full backlog history | `docs/backlog.md` | Session-end protocol | Yes | On demand |
| Domain rules | Directory-level CLAUDE.md | Human (reviewed) | Yes | On demand (path-scoped) |
| Project context | `docs/context/pack-*.md` | Session-end (summaries) | Yes | Per cursor specification |

**Rule**: If it must survive a machine change or be shared with the team, it goes
in a git-tracked file. Auto memory is per-machine working knowledge that
accelerates a single developer's sessions.

### 5.2 Session Cursor

**File**: `docs/.session-cursor.md`

The cursor is the single most important file in the system. It answers:
*"Where did we leave off, and what should we do next?"*

Structure:

```markdown
# Session Cursor

Last audited: YYYY-MM-DD
If this file conflicts with repo state, follow the repo and update this file.

## Last Updated
{DATE} (Session NN closed)

## System Version
ADOS v3

## Current Focus
{What implementation plan or milestone is active}

## Next Session
**Session NN**: {Title}
- Scope: {what to do}
- Packs: `core` + {list}
- Backlog: {PROJECT}-NNN
- Exit criteria: {what "done" looks like}

### Handover Notes
1. {Specific next steps for a fresh agent}
2. {Key files to read first}
3. {What comes after this session}

## Recent Decisions (last 10)
- D-YYYYMMDD-SNN-NN: {Decision} — {rationale}

## Blocked On
{none or list}

## Implementation Plan Status
| Session | Title | Status | Backlog IDs |
|---------|-------|--------|-------------|
| ... | ... | ... | ... |
```

Update rules:
- Updated at every session close
- Handover section must be specific enough that a fresh agent can start without re-reading everything
- Decisions section: only durable decisions, not implementation minutiae
- Keep under 100 lines — it's loaded every session

### 5.3 Session Logs

**Directory**: `docs/sessions/`

One log per session, created at session close. The audit trail.

Naming: `YYYY-MM-DD.md` or `YYYY-MM-DD-sNN.md` for multiple sessions per day.

Session logs serve two audiences:
- **Humans**: Understanding what changed and why (the audit trail)
- **Future agents**: Carry-forward context notes (the 5-10 bullet summary)

Keep active logs to the last 5 sessions. Rotate older logs to
`docs/archive/sessions/M{N}/` at milestone boundaries.

### 5.4 Auto Memory

**Directory**: `~/.claude/projects/<project>/memory/`

Auto memory is where Claude records working knowledge that persists across
sessions on the same machine. The first 200 lines of MEMORY.md are loaded
into every session automatically. Topic files load on demand.

Policy for MEMORY.md top section:
- `Last audited: YYYY-MM-DD`
- "If this file conflicts with repo state, follow the repo and update this file."
- Top 200 lines only = pinned essentials (facts, commands, sharp gotchas)
- Move detail to topic files (`decisions.md`, `patterns.md`, `debugging.md`)
- Never exceed the pinned cap

Maintain:
- `MEMORY.md` — pinned essentials only, top 200 lines maximum
- `decisions.md` — last 15-20 decisions for quick agent discovery
- `patterns.md` — code patterns that work in this project
- `debugging.md` — what broke and how it was fixed

Hygiene: review monthly, prune stale entries, keep pinned section under 200 lines.

---

## 6. Context Engineering

### 6.1 Context Packs

**Directory**: `docs/context/`

Packs are named bundles of cached knowledge about a project area. They prevent
the agent from reading the entire codebase at session start.

Each pack contains:

```markdown
# Context Pack: {name}

Last audited: YYYY-MM-DD
If this file conflicts with repo state, follow the repo and update this file.

## Summary (updated Session NN)
- 5-10 bullets of cached knowledge about this area
- What the key abstractions are
- What patterns to follow
- What changed recently

## Key Entrypoints
- `path/to/file` — what it is and when to read it

## Grep Recipes
- `grep -r "pattern" path/` — what this finds

## Do Not Read (unless explicitly needed)
- `path/to/generated/` — generated code, do not imitate
- `path/to/legacy/` — deprecated patterns

## Related Packs
- Pair with `pack-api` for full-stack work
```

### 6.2 Pack Discipline

1. The session cursor specifies which packs each session needs
2. Load only those packs — never use `full` by default
3. `core.md` is always loaded; others on demand
4. Scan directories (`ls`, `tree`, `glob`) before opening individual files
5. If expanding beyond assigned packs, record justification in the session log
6. Update pack summaries at session close when new knowledge was gained

### 6.3 Context Hygiene

- `/clear` between distinct tasks within a session
- If context exceeds ~60% capacity: summarise findings → write to auto memory → `/clear` → continue
- Before heavy file-read operations: check context pressure
- After a long exploratory or debugging sequence: summarise, compress, continue
- Pack summaries are the cheapest context — maintain them carefully

### 6.4 MCP Context Budget

If using MCP servers:
- Enable on-demand tool loading (`auto:5`) so definitions load when needed
- Set `MAX_MCP_OUTPUT_TOKENS` to prevent giant responses consuming the window
- Prefer MCP resources (`@server:...`) for targeted data over dumping full outputs
- Rule of thumb: if MCP tool definitions exceed 20K tokens, they're crowding out work

### 6.5 Always-Loaded Doc Freshness

Always-loaded documents must include:
- `Last audited: YYYY-MM-DD` near the top
- A repo-truth line: if docs conflict with the codebase, follow the repo and
  propose updating the doc

Minimum files:
- `CLAUDE.md`
- `docs/.session-cursor.md`
- `docs/context/core.md`
- `~/.claude/projects/<project>/memory/MEMORY.md` (top section)

---

## 7. Agent Orchestration

### 7.1 Lead Agent

The main Claude Code session. Handles implementation, user interaction, and
decision-making. Delegates read-heavy and review tasks to subagents to preserve
its own context quality.

### 7.2 Code Reviewer Subagent

**File**: `.claude/agents/code-reviewer.md`

Read-only. Reviews session work before commit. Calibrates depth to changeset.

```yaml
---
name: code-reviewer
description: Reviews session work before commit — read-only, complexity-aware
tools: Read, Glob, Grep, Bash
model: sonnet
---

You are a code reviewer. Review the current session's changes using `git diff`
and `git diff --stat`.

## Calibrate review depth

Determine changeset scale from `git diff --stat`:

**Large changes (>5 files, or introduces new abstractions/patterns):**
Review four dimensions, up to 4 issues per dimension:
1. Architecture — structural soundness, abstraction quality, coupling
2. Code quality — readability, consistency with existing patterns, DRY
3. Tests — coverage, edge cases, test quality
4. Performance — obvious inefficiencies, N+1 queries, unnecessary re-renders
Start each dimension with the highest-impact concern.

**Small changes (1-3 files, no new abstractions):**
Review the same four dimensions but flag only the single most important
issue per dimension. Skip dimensions with no concerns.

## Output format

For each issue found:
- Concrete file:line reference
- What the issue is
- Suggested fix (specific, not vague)

Final verdict: PASS / CONCERNS / BLOCK
- PASS: ship it
- CONCERNS: minor issues, safe to ship with awareness
- BLOCK: must fix before commit (use sparingly)

You cannot modify files. Observation and recommendation only.
```

### 7.3 Session Closer Subagent

**File**: `.claude/agents/session-closer.md`

Generates documentation at session close. Uses Sonnet for cost efficiency.

```yaml
---
name: session-closer
description: Generates session logs, updates cursor and backlog at session end
tools: Read, Write, Glob, Grep, Bash
model: sonnet
---

You are a session-closing specialist. Produce:
1. Classify close mode (`lite|standard|full`) from diff/risk
2. Updates to docs/.session-cursor.md (mark done, write handover)
3. Updates to docs/backlog-active.md (small active slice)
4. Session log in docs/sessions/YYYY-MM-DD.md for `standard|full`
5. Updates to docs/backlog.md only when history/status changed materially

Be concise. Carry-forward context notes: only what a fresh agent needs
to continue, not a transcript. Decision IDs: D-YYYYMMDD-SNN-NN format.

Update your memory with documentation patterns you discover.
```

### 7.4 Diagram Syncer Subagent (optional)

**File**: `.claude/agents/diagram-syncer.md`

Reviews git diff and updates PlantUML diagrams when structural changes occur.
Read + Write on `docs/diagrams/` only. Does not create new diagrams unless asked.

### 7.5 Subagent Design Principles

- Each subagent gets an **output contract**: what it returns and in what format
- Restrict tools to the minimum needed (code-reviewer gets no Write)
- Use Sonnet for cost efficiency on non-implementation tasks
- Subagents that accumulate project knowledge should maintain their own auto memory
- Delegate exploration, debugging, and audit work to subagents to preserve the
  lead agent's context quality

### 7.6 When NOT to Use Subagents

- Small, well-defined tasks the lead agent can handle in a few turns
- When the overhead of spawning + summarising exceeds the context savings
- Agent teams (parallel multi-agent) should be reserved for genuinely
  parallelisable work (e.g., 50-file migrations). For focused session work,
  the complexity and token cost isn't justified.

---

## 8. Quality Assurance

### 8.1 Quality Gates

Quality checks are mode-scoped (see §4.3):

**lite**
- Run the smallest targeted checks that prove the changed behavior.
- Escalate to full lint/typecheck/format if there are broad-impact signals
  (shared infra touched, widespread refactor, flaky signals).

**standard**
- Run:

```bash
{lint command}           # ESLint / ruff / equivalent
{typecheck command}      # TypeScript / mypy / equivalent
{format check command}   # Prettier / black / equivalent
```

**full**
- Run standard gates plus full test suite and any relevant integration/e2e.

Fix failures before committing. The agent should not skip checks needed for the
chosen risk tier.

### 8.2 Code Review Workflow

Integrated into session close protocol (Step 2) and calibrated by close mode:

**lite**
- Quick self-review only.

**standard**
- Self-review by default.
- Invoke code-reviewer when >5 files or new abstractions appear.

**full**
- Invoke code-reviewer subagent
- Review is complexity-aware (see §7.2)
- Address any BLOCK verdicts before committing
- CONCERNS are noted but don't block

Mode selection is auto-inferred from `git diff --stat` + risk triggers unless
the user explicitly chooses a mode.

### 8.3 Pre-Implementation Review

Part of session start (Step 5). For non-trivial work:

- 2-3 approach options with effort, risk, downstream impact, maintenance burden
- Recommended option with rationale
- "Do nothing" or "minimal change" included where reasonable
- User confirms before coding begins

This prevents the agent from silently committing to an approach the user
would have redirected.

### 8.4 Visual QA (for UI work)

When the session involves UI changes, run visual QA before close for
`standard|full` modes. In `lite`, run only the directly affected user path.

1. **Responsive check** — screenshots at 375px, 768px, 1440px
2. **Interaction flow** — click through the main user path
3. **Console check** — verify no JS errors

Uses MCP servers (Playwright, Chrome DevTools) when configured.

### 8.5 Diagram Sync

After sessions that change structure (new services, changed APIs, modified
data model), update relevant PlantUML diagrams in `full` mode, or in
`standard` when the change is clearly structural. This can be:
- Delegated to the diagram-syncer subagent
- Done manually by the lead agent
- Skipped if no structural changes occurred (note in session log)

---

## 9. Planning & Backlog

### 9.1 Backlog Model (Active Slice + Full History)

**Active file**: `docs/backlog-active.md`  
**Full file**: `docs/backlog.md`

Use a two-layer backlog:
- `docs/backlog-active.md` is always small and session-facing
- `docs/backlog.md` is full archive/history and milestone mapping

`docs/backlog-active.md` must contain:
- Current milestone
- 3-10 active items max
- Item IDs + acceptance criteria + current status

Every item in `docs/backlog.md` must include:

- **ID**: `{PROJECT}-NNN`
- **Status**: `idea | ready | in-progress | blocked | done | parked`
- **Priority**: `P0 | P1 | P2 | P3`
- **Epic**: E1–EN
- **Pack(s)**: relevant context packs
- **Acceptance Criteria**: checkboxes
- **Notes/Dependencies**: cross-references

A session mapping table in `docs/backlog.md` maps sessions to backlog IDs.
Group sessions into milestones for progress tracking.

Session-start loads `docs/backlog-active.md`. Open `docs/backlog.md` only when
the active slice is insufficient.

### 9.2 Implementation Plans

**Directory**: `docs/planning/`

For multi-session efforts. Each plan breaks work into sequential sessions
where each session produces a deployable increment.

Naming: `IMP-YYYY-MM-DD-short-slug.md`

Key sections: summary, goals/non-goals, session plan (with exit criteria
and test requirements per session), risks, open questions.

### 9.3 Task Packets

**Directory**: `docs/packets/`
**Command**: `/project:task-packet {PROJECT}-NNN`

Lightweight structured breakdown for complex backlog items. Not a full spec —
just enough to guide implementation: objective, non-goals, acceptance criteria,
work breakdown (DB / API / UI), file touch map, open questions.

Skipped for simple or well-defined tasks.

---

## 10. Decision Tracking

### 10.1 Format

```
D-YYYYMMDD-SNN-NN

Where:
  YYYYMMDD = date
  SNN      = session number
  NN       = sequence within session
```

Example: `D-20260227-S08-01: Use Express-style handlers over Next.js API routes — simpler testing, team familiarity`

### 10.2 What Gets a Decision Record

- Technology choices (library X over library Y)
- Architectural approach (how to structure a feature)
- Rejected alternatives (what was considered and why not)
- Business rule interpretations (how an ambiguous requirement was resolved)

Not recorded: trivial implementation choices, variable naming, file placement
that follows established convention.

### 10.3 Where Decisions Live

| Location | Purpose | Audience |
|----------|---------|----------|
| Session log `## Decisions` | Authoritative record with full context | Humans, audit |
| Session cursor `## Recent Decisions` | Cross-session visibility (last 10) | Next session's agent |
| Auto memory `decisions.md` | Agent-discoverable (last 15-20) | Agent quick lookup |

The session log is the source of truth. The cursor and memory are caches
for convenience.

---

## 11. Archive Policy

### 11.1 Session Log Rotation

- Keep the last 5 session logs in `docs/sessions/`
- When a milestone completes, move its logs to `docs/archive/sessions/M{N}/`
- Archived logs are never deleted

Rotation procedure:
```bash
mkdir -p docs/archive/sessions/M{N}
mv docs/sessions/{milestone-logs}*.md docs/archive/sessions/M{N}/
git commit -m "docs: rotate session logs for milestone M{N}"
```

### 11.2 CLAUDE.md Versioning

Before any major restructure of CLAUDE.md:
```bash
mkdir -p docs/archive/ados-v{N}
cp CLAUDE.md docs/archive/ados-v{N}/CLAUDE.md.v{N}
```

Include a README explaining what changed and why.

### 11.3 Why Archive Rather Than Delete

- Session logs are the audit trail for decisions and rationale
- Old CLAUDE.md versions show how the operating model evolved
- Archived files don't consume context (they're never loaded by the agent)
- Git history alone is insufficient — files moved/renamed lose easy discoverability

---

## 12. Slash Commands

### 12.1 `/project:session-start`

Triggers the full start protocol (§4.1). Reads cursor, checks environment,
loads core context + active backlog slice, evaluates work, presents plan,
awaits confirmation.

### 12.2 `/project:session-end`

Triggers risk-tiered close protocol (§4.3). Classifies mode
(`lite|standard|full`) from diff and risk triggers unless explicitly set:
`/project:session-end lite`, `/project:session-end standard`,
`/project:session-end full`.

Uses `context: fork` when close tasks are read-heavy. Applies only the checks
and documentation requirements required for the selected mode.

### 12.3 `/project:decision [title]`

Records a decision inline during a session:
1. Reads cursor for session number
2. Assigns next decision ID
3. Captures: decision, context, rationale, alternatives rejected
4. Writes to cursor and auto memory; writes to session log when present.
   If running `lite` without a log yet, create a minimal session log entry.
5. Reports the decision ID

### 12.4 `/project:task-packet {PROJECT}-NNN`

Generates a structured task breakdown for a backlog item before implementation.
Reads the backlog item, relevant packs, and spec, then produces a packet in
`docs/packets/`.

### 12.5 `/project:baseline-check`

Runs a quick A/B protocol to detect instruction drag:
1. Run task normally (capture tool-call count and time-to-first-working-diff)
2. Run same task with `--no-memory`
3. If baseline wins, reduce always-loaded context (imports, core docs, memory)

---

## 13. Hooks

### 13.1 SessionStart Hook

**File**: `.claude/hooks/session-start.sh`

Runs on session init. Checks for:
- Uncommitted changes (warns)
- Working on main/master branch (warns — create a feature branch)

### 13.2 Stop Hook

**File**: `.claude/hooks/stop-validate.sh`

Runs before session ends. Checks for:
- Missing `docs/backlog-active.md` (warns)
- Missing `docs/.session-cursor.md` (warns)
- Neither session log for today nor a cursor update for today (warns)

Can be upgraded to exit code 2 (blocking) once the team trusts the workflow.

### 13.3 PreCompact Hook

**File**: `.claude/hooks/pre-compact.sh`

Runs before context compaction. Backs up the transcript to a timestamped file
so no conversation history is permanently lost.

---

## 14. Adapting ADOS to a New Project

### Minimum Viable ADOS

Start with four files:
1. `CLAUDE.md` — project overview, commands, core rules, engineering preferences
2. `docs/.session-cursor.md` — what's next, what's done
3. `docs/backlog-active.md` — current milestone + 3-10 active items
4. `docs/backlog.md` — full backlog history

This is enough for governed sessions. Add components as sessions accumulate.

### Progressive Enhancement

| After... | Add... |
|----------|--------|
| 3 sessions | Context packs (`docs/context/`) — pack summaries emerge from session notes |
| 5 sessions | Slash commands — start/end protocols stabilise enough to codify |
| First milestone | Session log archiving (`docs/archive/`) |
| First complex feature | Task packets and implementation plans |
| Recurring review needs | Code-reviewer subagent |
| Multiple domains | Directory-level CLAUDE.md files |
| Auto memory enabled | Seed MEMORY.md from session log context notes |

### Full Bootstrap

Use `ADOS-INIT.md` — the 12-phase initialization guide that creates the
complete framework from scratch with `[ASK]` prompts for project-specific input.

---

## 15. Ongoing Maintenance

### Weekly
- Review and update context pack summaries after sessions that changed domain knowledge
- `/clear` discipline — verify it's happening (check session logs for context notes)

### Per Milestone
- Rotate session logs to archive
- Review implementation plan status against backlog
- Check for stale backlog items (parked items older than 2 milestones — either revive or remove)

### Monthly
- Review auto memory: prune stale entries, keep MEMORY.md pinned section under 200 lines
- Review CLAUDE.md: is every instruction still triggered? Remove dead rules.
- Enforce no-net-growth in always-loaded rules (add one, remove/shrink one)
- Review directory-level CLAUDE.md files: still accurate?

### Quarterly
- Snapshot CLAUDE.md to archive before any major changes
- Review ADOS process itself: what's working, what's friction?
- Consider new subagents for recurring pain points

---

## Appendix A: Session Log Template

```markdown
# Session Log — YYYY-MM-DD

## Close Mode
`lite | standard | full` + brief rationale

## Objective
{What this session set out to do}

## Active Backlog IDs
{PROJECT}-NNN

## Packs Loaded
`core`, `pack-{x}`

## Files Read
- `path` — why (context-loading reads only, not every file touched)

## Work Completed
{Summary — not a transcript of every edit}

## Checks Run
- {targeted checks or full gates based on mode}

## Decisions
- D-YYYYMMDD-SNN-NN: {Decision} — {rationale}

## Backlog Updates
- {PROJECT}-NNN: {old status} → {new status}

## Review Verdict
{PASS / CONCERNS / BLOCK — or "skipped: small changeset"}

## Optional Heavy Sections (standard/full only)
- Files Read (context-loading reads only)
- Diagram updates
- Auto-memory writes

## Next Session Should
1. {Specific next step}
2. {Key files to read}
3. {What comes after}

## Context Notes (carry-forward, 5-10 bullets max)
- {Insight that saves the next session time}
```

---

## Appendix B: Context Pack Template

```markdown
# Context Pack: {name}

Last audited: YYYY-MM-DD
If this file conflicts with repo state, follow the repo and update this file.

## Summary (updated Session NN)
- {What this area covers}
- {Key abstractions}
- {Patterns to follow}
- {What changed recently}
- {Current state / known issues}

## Key Entrypoints
- `path/to/file` — what it is and when to read it

## Grep Recipes
- `grep -r "pattern" path/` — finds {what}

## Do Not Read
- `path/to/generated/` — generated, don't imitate
- `path/to/legacy/` — deprecated patterns

## Related Packs
- Pair with `pack-{x}` for {type of} work
```

---

## Appendix C: Implementation Plan Template

```markdown
# IMP-YYYY-MM-DD — {Title}

## Summary
{What this plan delivers}

## Goals
- {Goal 1}

## Non-Goals
- {Explicitly out of scope}

## Scope & Dependencies
- Backlog IDs: {list}
- Prerequisite plans/sessions: {list}

## Session Plan

### Session NN — {Title}
- Scope: {what to build}
- Packs: `core` + {list}
- Backlog: {PROJECT}-NNN
- Tests: {what to test}
- Exit criteria: {definition of done}

### Session NN+1 — {Title}
...

## Risks & Assumptions
- {Risk 1}

## Open Questions
- {Question 1}
```

---

## Appendix D: CLAUDE.md Template

```markdown
# {Project Name}

Last audited: YYYY-MM-DD
If this file conflicts with repo state, follow the repo and update this file.

## Overview
{2-3 sentences: what, who, stage}

## Tech Stack
{Concise list}

## Project Structure
{5-10 line directory map}

## Commands
- `{build}`: Build
- `{dev}`: Dev server
- `{lint}`: Lint
- `{typecheck}`: Type check
- `{format}`: Format
- `{test}`: Test

## Commit Conventions
feat: | fix: | refactor: | docs: | test: | chore:

## Session Protocol
- Start: `/project:session-start`
- End: `/project:session-end [lite|standard|full]`
- Between tasks: `/clear`
- Context pressure (>60%): summarise → `/clear` → continue

## Core Rules
- Backlog-first: never start work without active backlog IDs
- Evaluate before implementing: spec → scope → deps → test strategy
- Select close mode by risk; default to the lightest safe mode
- `standard` gates: `{lint} && {typecheck} && {format}`
- `full` gates: standard + full test suite
- Decisions get IDs: D-YYYYMMDD-SNN-NN format
- Work on feature branches, not main
- No net growth for always-loaded rules (add one, remove/shrink one)

## Engineering Preferences
- Explicit over clever — boring, obvious code wins
- DRY within a module; tolerate duplication across boundaries to reduce coupling
- Prefer a test over none, but choose the smallest test that proves behavior.
  Run full suites at commit gate or when risk is broad.
- Handle edge cases at boundaries; trust internals
- "Engineered enough" = known requirements + obvious edge cases, no speculative abstraction
- Uncertain between approaches → present options, don't pick silently
- Multi-step work → confirm after first step before building on assumptions

## Context Loading
- Read docs/.session-cursor.md for current state
- Read docs/backlog-active.md for current milestone + active IDs
- Load only cursor-specified context packs
- @docs/context/core.md (always)
- Backlog lives at docs/backlog.md (open only when active slice is insufficient)
- Scan directories before opening files

## References
@docs/context/core.md
```

Target: ≤80 lines. Every instruction must earn its place.

---

## Appendix E: `docs/backlog-active.md` Template

```markdown
# Active Backlog Slice

Last audited: YYYY-MM-DD
If this file conflicts with repo state, follow the repo and update this file.

## Current Milestone
M{N}: {milestone name}

## Active Items (3-10 max)

### {PROJECT}-NNN — {title}
- Status: ready | in-progress | blocked
- Priority: P0 | P1 | P2 | P3
- Packs: core, pack-{x}
- Acceptance Criteria:
  - [ ] {criterion 1}
  - [ ] {criterion 2}
- Notes/Dependencies: {optional}

### {PROJECT}-NNN — {title}
- Status: ready | in-progress | blocked
- Priority: P0 | P1 | P2 | P3
- Packs: core, pack-{x}
- Acceptance Criteria:
  - [ ] {criterion 1}
- Notes/Dependencies: {optional}

## Fallback
If this slice is insufficient, open `docs/backlog.md` for full history.
```

---

## Appendix F: `.claude/commands/baseline-check.md` Template

```markdown
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
   - If `--no-memory` is faster/cleaner, reduce always-loaded context:
     - remove non-essential `@imports`
     - shrink always-loaded docs
     - move detail from MEMORY.md into topic files
5. Record result in session log context notes (or cursor notes in `lite` mode).
```
