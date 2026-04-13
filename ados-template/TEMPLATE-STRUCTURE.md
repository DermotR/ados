# ADOS Template Structure

Version: ADOS template v4

```text
ados-template/
├── copier.yml
├── TEMPLATE_VERSION
├── README.md
├── TEMPLATE-STRUCTURE.md
├── GENERATOR-FLOW.md
├── scripts/
│   ├── init-ados.sh
│   └── smoke-test.sh
└── template/
    ├── .ados/
    │   └── render-ados.sh
    ├── .gitignore
    ├── CLAUDE.md
    ├── CLAUDE.local.md
    ├── .claude/
    │   ├── settings.json
    │   ├── commands/
    │   │   ├── session-start.md
    │   │   ├── session-end.md
    │   │   ├── decision.md
    │   │   ├── pack-create.md
    │   │   └── baseline-check.md
    │   ├── hooks/
    │   │   ├── session-start.sh
    │   │   ├── stop-validate.sh
    │   │   └── pre-compact.sh
    │   └── agents/
    │       ├── session-closer.md
    │       ├── code-reviewer.md
    │       └── diagram-syncer.md
    └── docs/
        ├── NOW.md
        ├── TOPICS.md
        ├── foundation/overview.md
        ├── foundation/diagrams/.gitkeep
        ├── topics/bootstrap/INDEX.md
        ├── topics/bootstrap/cursor.md
        ├── topics/bootstrap/requirements.md
        ├── topics/bootstrap/plan.md
        ├── sessions/SESSION-TEMPLATE.md
        └── archive/
            ├── README.md
            ├── process/.gitkeep
            ├── sessions/.gitkeep
            └── topics/.gitkeep
```

Design rule: keep always-loaded content small and stable; push detail to on-demand files.
Operational rule: use risk-tier close modes (`lite|standard|full`) to avoid
running heavy close steps on low-risk changes.
Bootstrap rule: detect monorepos early and persist workspace tool/scope in
`CLAUDE.md` and `docs/foundation/overview.md`, then start from a bootstrap pack.
Pack rule: keep seam requirements and plans inside `docs/topics/<slug>/`.
Diagram rule: keep diagrams pack-local unless they are genuinely cross-pack or system-wide.
