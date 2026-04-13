# Requirements

## Problem Statement

ADOS v3 was conceptually strong, but one active workstream could be split across
cursor, backlog, context packs, planning files, packets, and a global spec tree.
That made the working set larger than necessary and blurred where canon lived.

This redesign exists to make requirements and planning easier to find, easier to
maintain, and more aligned with how agentic sessions actually work.

## Goals

- make topic packs the canonical unit of requirements and planning
- keep root docs minimal and coordination-only
- reduce the default read/write set for a focused session
- keep process docs, scaffold, scripts, and this repo's own docs aligned
- provide a practical migration path for existing ADOS repos

## Constraints

- preserve useful session lifecycle and quality-gate ideas from v3
- do not recreate backlog under another name
- do not keep a second global spec tree as hidden canon
- keep the generated scaffold small and teachable

## Non-Goals

- restoring backlog in this pass
- preserving every v3 doc class for compatibility
- writing a giant root-level meta-spec for every pack

## Current Truth

- `ADOS-v4-PROCESS.md` is written
- the scaffold under `ados-template/` is now pack-first
- smoke tests pass for both init and copier paths
- this repo itself is now using the v4 `docs/` shape

## Canonical Direction

- root docs: `NOW`, `TOPICS`, `foundation`
- seam canon: `docs/topics/<slug>/`
- audit trail: `docs/sessions/`
- migration guidance: explicit and discoverable, not implicit in process prose

## Open Requirement Questions

- should the temp working-plan file be kept temporarily or retired now that the pack exists?
- when should old v3/v2 references be physically archived beyond their current root-doc status?
