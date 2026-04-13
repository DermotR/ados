# Bootstrap Requirements

## Problem Statement

A fresh ADOS v4 scaffold needs just enough canon to start work cleanly without recreating the old backlog/spec/planning sprawl.

## Goals

- establish the shared project overview
- confirm root commands and local workflow
- create the first real topic pack for active work
- keep bootstrap small and short-lived

## Constraints

- use root docs only for control and cross-pack context
- keep seam requirements and plans inside packs
- avoid recreating backlog concepts under another filename

## Non-Goals

- documenting the entire product surface up front
- keeping bootstrap as the long-term home for real requirements
- building a second global spec tree

## Current Truth

- root control docs exist
- foundation overview exists but needs real project detail
- bootstrap is the only active pack at scaffold time

## Canonical Direction

- the first real seam should get its own pack under `docs/topics/`
- bootstrap should become reference-only once real pack work starts
- shared truths that multiple packs need should live in `docs/foundation/overview.md`

## Open Requirement Questions

- what seam should become the first real pack in this repo?
- is there any cross-pack architecture canon that already deserves a separate `docs/foundation/architecture.md`?
