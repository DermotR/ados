# ADOS

Agentic Development Operating System (ADOS) for governed AI-assisted software delivery.

## Contents

- `ADOS-v2-PROCESS.md`: process reference and templates
- `ados-template/`: scaffold + initializer + copier template

## Initialize A New Project

From inside your new project folder:

```bash
bash /path/to/ados/ados-template/scripts/init-ados.sh .
```

If the folder is not empty:

```bash
bash /path/to/ados/ados-template/scripts/init-ados.sh . --force
```

Non-interactive:

```bash
bash /path/to/ados/ados-template/scripts/init-ados.sh \
  --target . \
  --non-interactive \
  --project-name "My Project" \
  --project-stage "MVP" \
  --tech-stack "TypeScript, Next.js, Postgres"
```

Copier alternative:

```bash
copier copy /path/to/ados/ados-template .
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
