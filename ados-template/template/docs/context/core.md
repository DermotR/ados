# Core Context

Last audited: __AUDIT_DATE__
If this file conflicts with repo state, follow the repo and update this file.

## Project Facts
- Name: __PROJECT_NAME__
- Stage: __PROJECT_STAGE__
- Stack: __TECH_STACK__

## Key Paths
- __KEY_PATHS__

## Workspace Profile
- Monorepo mode: __MONOREPO_MODE__
- Workspace tool: __WORKSPACE_TOOL__
- Primary scope: __WORKSPACE_SCOPE__

## Guardrails
- Use active backlog slice before opening full backlog.
- Keep always-loaded docs lean and stable.
- Treat `docs/spec/` as requirement source-of-truth:
  `product-overview.md`, `use-cases.md`, `business-rules.md`, `diagrams/`.
- Use `lite` session close by default; escalate to `standard|full` on risk triggers.
- In monorepos, escalate at least to `standard` when a change spans multiple workspaces.
- If instructions conflict with code, follow code and update docs.
