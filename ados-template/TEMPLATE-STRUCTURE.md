# ADOS Template Structure

Version: ADOS template v3

```text
ados-template/
├── copier.yml
├── TEMPLATE_VERSION
├── README.md
├── TEMPLATE-STRUCTURE.md
├── GENERATOR-FLOW.md
├── scripts/
│   └── init-ados.sh
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
    │   │   ├── task-packet.md
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
        ├── .session-cursor.md
        ├── backlog-active.md
        ├── backlog.md
        ├── context/core.md
        ├── planning/IMPLEMENTATION-PLAN-TEMPLATE.md
        ├── sessions/SESSION-TEMPLATE.md
        ├── packets/.gitkeep
        ├── diagrams/.gitkeep
        ├── spec/.gitkeep
        └── archive/README.md
```

Design rule: keep always-loaded content small and stable; push detail to on-demand files.
Operational rule: use risk-tier close modes (`lite|standard|full`) to avoid
running heavy close steps on low-risk changes.
