# /project:session-start

1. Read `docs/.session-cursor.md`.
2. Check environment (`git status`, branch, required services).
3. Load:
   - `docs/context/core.md`
   - `docs/backlog-active.md`
   - cursor-specified packs only
   - `docs/spec/product-overview.md` + `docs/spec/use-cases.md` when validating requirements or UX flow
   - `docs/spec/business-rules.md` when decisions involve rule interpretation/enforcement
   - nearest path-scoped `CLAUDE.md` when working in monorepos
4. Open `docs/backlog.md` only when active slice is insufficient.
5. Confirm workspace scope for this task (package/app/path) in monorepos.
6. Evaluate task (spec, scope, dependencies, test strategy).
7. Propose expected close mode (`lite|standard|full`) based on risk.
8. Present concise plan and wait for confirmation before coding.
