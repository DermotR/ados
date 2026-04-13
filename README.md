# ADOS

Agentic Development Operating System (ADOS) for governed AI-assisted software delivery.

## End User Quick Start (VS Code)

1. Install prerequisites:
- `git`
- `bash` (macOS/Linux terminal, or Git Bash on Windows)
- VS Code

2. Clone ADOS once:

```bash
git clone https://github.com/DermotR/ados.git ~/tools/ados
```

3. Create/open your new project folder in VS Code.

4. In the VS Code terminal, from inside your project folder, run:

```bash
bash ~/tools/ados/ados-template/scripts/init-ados.sh .
```

5. If your project folder is not empty, run:

```bash
bash ~/tools/ados/ados-template/scripts/init-ados.sh . --force
```

`--force` merges ADOS files into an existing repo. Commit or back up first if you
already have `CLAUDE.md`, `.claude/`, or `docs/` content you care about.

6. Complete setup:
- Fill `docs/foundation/overview.md`.
- Review `docs/NOW.md`, `docs/TOPICS.md`, and the starter pack under `docs/topics/bootstrap/`.
- Create the first real topic pack for the seam you are actively working on.
  Use `/project:pack-create [topic-slug] [purpose]` or create `docs/topics/<slug>/`
  with `INDEX.md`, `cursor.md`, `requirements.md`, and `plan.md`.
- Update `docs/NOW.md` and `docs/TOPICS.md` so the real pack becomes active and
  `bootstrap` becomes reference-only.
- Review `CLAUDE.md` commands and key paths.
- Start with `/project:session-start`.
- Close sessions with `/project:session-end [lite|standard|full]` (default to lightest safe mode).
- Commit the bootstrap files.

Note: if monorepo signals are detected (`pnpm-workspace.yaml`, `turbo.json`,
`nx.json`, `workspaces`), init applies a workspace-aware profile automatically.
If an existing repo still has `docs/diagrams/`, init migrates those diagrams to
`docs/foundation/diagrams/`.

## Repo Contents

- `ADOS-v4-PROCESS.md`: current process reference
- `ADOS-v4-MIGRATION.md`: migration guide for existing ADOS repos
- `ADOS-v3-PROCESS.md`: previous version (archived reference)
- `ADOS-v2-PROCESS.md`: older archived reference
- `ados-template/`: scaffold + initializer + copier template

## Alternative Init Paths

Non-interactive:

```bash
bash ~/tools/ados/ados-template/scripts/init-ados.sh \
  --target . \
  --non-interactive \
  --project-name "My Project" \
  --project-stage "MVP" \
  --tech-stack "TypeScript, Next.js, Postgres" \
  --foundation-overview "Briefly describe the project and what it is trying to achieve"
```

Copier alternative:

```bash
copier copy ~/tools/ados/ados-template .
```

## Local Validation

Run a self-contained smoke test before publishing:

```bash
bash ados-template/scripts/smoke-test.sh
```

## Publish Checklist

1. Run `bash ados-template/scripts/smoke-test.sh`
2. Create repo `github.com/DermotR/ados`
3. Push contents of this directory
4. Verify GitHub Actions workflow passes
