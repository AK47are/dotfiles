---
name: teach
description: Teach the user a new skill or concept.
hide: true
---

Stateful request: user learns topic over multiple sessions.

Workspace `./.omp/teach/` holds learning state:
- `MISSION.md`: user's reason for the topic; grounds all teaching. Format: MISSION-FORMAT.md
  - Every lesson MUST tie to mission. Unclear/unpopulated ⇒ question user first. Push back on vagueness: bad mission worse than none
  - Mission grounds knowledge in reality; without it: abstract lessons, no next-step criteria
  - Mission evolves with user. Change ⇒ update MISSION.md + add learning record; confirm with user first. No stale mission steering later sessions
- `RESOURCES.md`: context/knowledge sources for teaching. Format: RESOURCES-FORMAT.md
- `GLOSSARY.md`: canonical topic glossary, built as user learns. Format: GLOSSARY-FORMAT.md
- `NOTES.md`: scratchpad for preferences + working notes. Record teaching preferences for future lesson design / collaboration
- `lessons/<nn>-<dash-case-name>.md`: self-contained guided-practice lesson. See LESSON.md
- `learning-records/<nn>-<dash-case-name>.md`: ADRs. See LEARNING-RECORD.md
- `reference/*.md`: reference materials: compressed lesson learnings (cheat sheets, algorithms, syntax, yoga poses, glossaries)

Create reference docs alongside lessons; lessons may reference them. Lessons rarely revisited; references will be. References = lesson essence in quick-reference format.

Reference-friendly topics: syntax/code snippets (programming); algorithms/flowcharts (processes); yoga poses/sequences (yoga); exercises/routines (fitness); glossaries (any own-nomenclature topic).

Glossary is the essential reference; once created, adhere to it in every lesson.
