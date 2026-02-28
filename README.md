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

6. Complete setup:
- Fill `docs/backlog-active.md` with current milestone + 3-10 active items.
- Review `CLAUDE.md` commands and key paths.
- Start with `/project:session-start`.
- Close sessions with `/project:session-end [lite|standard|full]` (default to lightest safe mode).
- Commit the bootstrap files.

## Repo Contents

- `ADOS-v3-PROCESS.md`: current process reference and templates
- `ADOS-v2-PROCESS.md`: previous version (archived reference)
- `ados-template/`: scaffold + initializer + copier template

## Alternative Init Paths

Non-interactive:

```bash
bash ~/tools/ados/ados-template/scripts/init-ados.sh \
  --target . \
  --non-interactive \
  --project-name "My Project" \
  --project-stage "MVP" \
  --tech-stack "TypeScript, Next.js, Postgres"
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
