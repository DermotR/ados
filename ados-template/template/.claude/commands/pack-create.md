# /project:pack-create [topic-slug] [purpose]

Create a new topic pack under `docs/topics/<topic-slug>/`.

When you create it:

1. Add these required files:
   - `INDEX.md`
   - `cursor.md`
   - `requirements.md`
   - `plan.md`
2. Keep the pack focused on one seam.
3. Use this minimum structure:
   - `INDEX.md`: purpose, scope, read order, file guide, related docs, current stance
   - `cursor.md`: current status, what was locked, next step, warnings
   - `requirements.md`: problem statement, goals, constraints, non-goals, current truth, canonical direction, open questions
   - `plan.md`: current state, next recommended step, work chunks, checklist, open implementation questions
4. Update:
   - `docs/NOW.md` so the new pack becomes active
   - `docs/TOPICS.md` so the new pack is indexed correctly
5. If `bootstrap` was the active starter pack, demote it to reference once the new pack is active.

Do not create a pack for a tiny one-off fix with no lasting canon.
