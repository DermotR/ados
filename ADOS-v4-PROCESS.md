# Agentic Development Operating System (ADOS) v4

## Process Reference

---

## 1. What ADOS v4 Is

ADOS is the operating layer between a coding agent and real project work.
It defines how sessions begin, how work stays coherent across stateless runs,
how requirements and plans remain discoverable, and how close-out artifacts
stay useful instead of turning into documentation sprawl.

ADOS v4 keeps the governance ideas from v3, but changes the information
architecture:

- no backlog by default
- no global spec tree as the main canon
- topic packs become the canonical unit of requirements and planning
- root docs become a control plane, not a second source of truth

The main goal is simple: most sessions should need one root control doc and
one active topic pack, not six different documentation buckets.

### 1.1 The Core Loop

```text
Read root control docs -> read active pack -> evaluate -> implement -> review
-> update pack canon/handoff -> log session
```

### 1.2 Design Principles

- Pack-first: requirements and planning live with the seam they govern.
- Root stays thin: root docs coordinate work, they do not restate pack truth.
- One evolving plan per seam: avoid piles of plan artifacts.
- Volatile vs durable must stay explicit: handoff notes are not canon.
- Fewer default reads: only load what the active seam actually needs.
- No renamed backlog: `NOW.md` is a handoff/control doc, not a queue history.

---

## 2. File Map

```text
CLAUDE.md
CLAUDE.local.md

.claude/
├── commands/
│   ├── session-start.md
│   ├── session-end.md
│   ├── decision.md
│   ├── pack-create.md
│   └── baseline-check.md
├── agents/
│   ├── session-closer.md
│   ├── code-reviewer.md
│   └── diagram-syncer.md
├── hooks/
│   ├── session-start.sh
│   ├── stop-validate.sh
│   └── pre-compact.sh
└── settings.json

docs/
├── NOW.md                                 # active focus and immediate handoff
├── TOPICS.md                              # topic catalog and status index
├── foundation/
│   ├── overview.md                        # shared project truths reused across packs
│   ├── architecture.md                    # optional cross-pack architecture canon
│   └── diagrams/                          # optional cross-pack/system diagrams
├── topics/
│   └── <topic-slug>/
│       ├── INDEX.md                       # pack entrypoint and read order
│       ├── cursor.md                      # volatile handoff for this seam
│       ├── requirements.md                # canonical seam requirements
│       ├── plan.md                        # canonical seam plan and sequencing
│       ├── solution.md                    # optional design model
│       ├── manual.md                      # optional local operating rules
│       ├── diagrams/                      # optional pack-local diagrams
│       └── references/                    # optional supporting material
├── sessions/
│   ├── SESSION-TEMPLATE.md
│   └── YYYY-MM-DD.md
└── archive/
    ├── README.md
    ├── process/
    ├── sessions/
    └── topics/
```

### 2.1 Defaults

- `docs/foundation/overview.md` is the only required file under `docs/foundation/`.
- `manual.md` is optional and should stay rare.
- Diagrams live pack-local by default.
- Session logs remain global, not pack-local.
- Old doc classes such as `backlog`, `planning`, `packets`, and `spec` do not
  exist in the default v4 scaffold.

---

## 3. Root Docs

### 3.1 `CLAUDE.md`

`CLAUDE.md` is the root constitution. Keep it lean:

- project overview
- stack
- key paths
- commands
- session protocol pointers
- stable core rules
- engineering preferences
- minimal context loading rules

Budget imports like dependencies. Import only small, stable files such as:

```markdown
@docs/foundation/overview.md
```

Do not import:

- `docs/NOW.md`
- pack `cursor.md`
- pack `plan.md`
- session logs

Those are high-churn and should be opened on demand.

### 3.2 `docs/NOW.md`

`NOW.md` is the active control plane for the current moment.

It should answer:

- what is the current focus?
- which packs are active right now?
- what exact files should the next session read first?
- what is the immediate next step?
- what current watchouts matter?

Rules:

- max 3 active packs
- no queue of unrelated future work
- no long history
- no acceptance criteria matrix

If `NOW.md` starts looking like a roadmap, it is doing the wrong job.

### 3.3 `docs/TOPICS.md`

`TOPICS.md` is the pack index:

- active packs
- reference packs
- parked packs
- archived packs

Keep entries short: slug, purpose, status, and adjacent dependencies when useful.

### 3.4 `docs/foundation/`

`docs/foundation/` exists only for truths reused across multiple packs.

Good examples:

- project-wide overview
- stable architecture boundaries used by many packs
- system-level diagrams

Bad examples:

- requirements that only apply to one seam
- a copy of pack plans
- catch-all design notes

---

## 4. Topic Packs

Topic packs are the canonical unit of requirements and planning.

Each active seam should have one pack that tells a fresh agent:

- what this seam is
- what is currently true
- what the intended canon is
- what to do next

### 4.1 Required Files

#### `INDEX.md`

The pack entrypoint:

- purpose
- scope / out-of-scope
- read order
- file guide
- related packs and docs
- current stance/status

#### `cursor.md`

Volatile handoff for this seam:

- current status
- what was locked
- next step
- warnings / things not to regress

Keep it short and rewrite often.

#### `requirements.md`

Canonical seam requirements:

- problem statement
- goals
- constraints
- non-goals
- current truth
- canonical direction
- open requirement questions

#### `plan.md`

Canonical seam plan:

- current state
- next recommended step
- work chunks or phases
- checklist
- open implementation questions

### 4.2 Optional Files

Use only when they earn their keep:

- `solution.md`
- `manual.md`
- `diagrams/`
- `references/`

### 4.3 Pack Ownership Rules

- If a truth only matters to one seam, it belongs in that pack.
- If a truth is reused across multiple packs, promote it to `docs/foundation/`.
- `cursor.md` is volatile. Promote durable canon into `requirements.md` or `plan.md`.
- One pack should own one seam. If a pack starts covering multiple seams, split it.

### 4.4 Pack Lifecycle

Create a new pack when at least two are true:

- the work will span multiple sessions
- the seam needs its own canon
- there are meaningful open questions or design choices
- the work will likely be resumed after interruption
- absorbing it into another pack would make that pack materially harder to use

Do not create a pack for:

- a one-off bug with no lasting canon
- a tiny code-only change already covered by an existing pack

Split a pack when:

- sessions routinely need only one subsection
- `requirements.md` or `plan.md` is mixing distinct seams
- multiple next steps have different read paths
- the pack needs its own internal index to stay usable

Archive a pack when:

- its canon is settled and no active work depends on it
- it has been superseded
- it is no longer on the active operating surface

---

## 5. Session Lifecycle

### 5.1 Session Start

Triggered by: `/project:session-start`

Default read order:

1. `CLAUDE.md`
2. `docs/NOW.md`
3. active pack `INDEX.md`
4. active pack `cursor.md`
5. active pack `requirements.md` and `plan.md` as needed
6. `docs/foundation/*` only when the active seam depends on shared canon
7. nearest path-scoped `CLAUDE.md` when working in a scoped directory

Then:

1. Check environment
   - `git status`
   - branch
   - required local services if relevant
2. Confirm workspace/package/path scope when relevant
3. Evaluate before implementing
   - requirements alignment
   - scope
   - dependencies
   - test strategy
4. For non-trivial work, present options and wait for confirmation
5. State expected close mode: `lite`, `standard`, or `full`

Rule:

- a normal session should not need to open a backlog file, a planning directory,
  and a global spec tree before it can start focused work

### 5.2 Session Execution

During implementation:

- keep the active seam tied to its pack
- update pack canon when the seam truth changes
- use `/clear` between distinct tasks when context gets muddy
- confirm direction with the user after the first meaningful step of multi-step work
- record durable decisions when they affect canon or future direction

### 5.3 Session End

Triggered by: `/project:session-end [lite|standard|full]`

Close mode:

- `lite`: small, low-risk changes; targeted checks only
- `standard`: normal feature work; lint + typecheck + format check
- `full`: cross-cutting/high-risk/release-critical; standard checks + fuller validation

Default write order:

1. update active pack `cursor.md`
2. update active pack `plan.md` if progress/sequence/open questions changed
3. update active pack `requirements.md` if canon changed
4. update `docs/NOW.md` only if focus or immediate handoff changed
5. update `docs/TOPICS.md` only if pack status changed
6. write session log when the mode or change scope justifies it
7. update diagrams only when structure changed

Rule:

- session close should usually touch one pack and maybe `NOW.md`, not multiple
  global document buckets

---

## 6. Decisions And Logs

### 6.1 Decision Records

Use IDs:

```text
D-YYYYMMDD-SNN-NN
```

Record durable decisions when they affect:

- architecture
- approach
- requirement interpretation
- rejected alternatives with downstream consequences

### 6.2 Where Decisions Live

- session logs are the authoritative historical record
- packs get updated when a decision changes canon
- `NOW.md` only changes if the decision affects the immediate next handoff
- auto memory may keep discoverable summaries, but git-tracked pack/root docs are
  the shared source of truth

### 6.3 Session Logs

Session logs remain the audit trail:

- what changed
- checks run
- decisions
- docs updated
- next-session handoff

Keep active logs in `docs/sessions/` and archive older material under
`docs/archive/sessions/`.

---

## 7. Agents, Hooks, And QA

### 7.1 Session Closer

The session closer should operate on the v4 model:

- classify close mode
- update active pack `cursor.md`
- update pack `plan.md` / `requirements.md` when canon changed
- update `docs/NOW.md` if focus changed
- update `docs/TOPICS.md` if pack status changed
- write session log

### 7.2 Diagram Syncer

Diagrams may live in:

- `docs/topics/<slug>/diagrams/`
- `docs/foundation/diagrams/`

Do not assume a single global spec diagram directory.

### 7.3 Hooks

Hooks should enforce the new shape lightly:

- warn if `docs/NOW.md` or `docs/TOPICS.md` is missing
- warn if neither today’s session log nor any relevant handoff doc shows a close update
- avoid hard-coding backlog or spec paths

### 7.4 Quality Gates

Risk-tier close modes remain useful in v4:

- `lite`: smallest checks proving behavior
- `standard`: lint + typecheck + format check
- `full`: standard checks + broader tests/review as justified

The pack-first documentation model changes where truth lives, not the need for
engineering discipline.

---

## 8. Bootstrap

The default scaffold should create:

- a thin root control plane
- a thin foundation overview
- one bootstrap pack

The bootstrap pack exists only to:

- confirm commands and local workflow
- establish the first real shared project overview
- identify the first real topic pack(s)
- then get out of the way

The bootstrap pack should become reference or archived once real topic packs
take over.

Helpful bootstrap rule:

- after creating the first real pack, update `docs/NOW.md` and `docs/TOPICS.md`
  immediately so future sessions stop defaulting to `bootstrap`

---

## 9. Migration Direction From v3

High-level mapping:

- `docs/.session-cursor.md` -> `docs/NOW.md` + pack `cursor.md`
- `docs/backlog-active.md` -> removed
- `docs/backlog.md` -> removed
- `docs/context/core.md` -> `CLAUDE.md` + `docs/foundation/overview.md`
- `docs/planning/*` -> pack `plan.md`
- `docs/packets/*` -> fold into pack `plan.md` or `references/`
- `docs/spec/*` -> pack canon, except genuinely cross-pack material promoted to
  `docs/foundation/`

Principle:

- do not preserve v3 categories by inertia
- if a v3 artifact has no clean role in v4, delete or archive it

---

## 10. Operating Rule

Prefer one coherent pack-first model over incremental compatibility.
If the agent can only explain where truth lives by saying "it depends," the
documentation model is still too complicated.
