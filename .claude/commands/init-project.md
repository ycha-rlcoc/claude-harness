Initialize project documentation by interviewing the user and generating populated content for all four project docs and starter domain specs.

Ask these questions one at a time — wait for each answer before continuing:

1. "In one or two sentences, what does this project do and who uses it?"

2. "What are you building with? (framework, database, auth, deployment — list what you know so far)"

3. "Who uses this app and do they have different roles? Describe each role in one sentence."

4. "What's the first thing you want to build, or what phase are you in right now?"

5. "Does this project handle sensitive data or have compliance requirements? (or 'none')"

6. "Have you already decided on any technology choices? What's still open?"

After all answers, generate and write these files using the templates in `templates/` as the structure:

- `CURRENT.md` — infrastructure table with real stack from Q2, next priorities from Q4
- `ARCHITECTURE.md` — stack from Q2, domain terms from Q3, data rules from Q5
- `DECISIONS.md` — initial entries for any already-decided choices from Q6
- `SESSIONS.md` — header only (the hook auto-populates sessions)
- Update `CLAUDE.md` — fill in the project overview from Q1, add rules from Q5

Also create starter domain spec files in `docs/specs/` based on the roles and domains identified in Q3. For each domain:
- Copy the structure from `docs/specs/_template.md`
- Populate "Use cases by role" from Q3
- Leave other sections with a comment: `<!-- Populate as this domain gets built -->`

Do not leave placeholder text in the generated files — use the actual answers. Mark truly unknown items as 📋 Planned.

After generating, show a summary of what was created and ask: "Does this look right? I can adjust anything before we commit."

If confirmed, run:
```
git add -A
git commit -m "init: project documentation and domain spec scaffolding"
```
