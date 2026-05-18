# /init-project

Run once after `bash scripts/setup.sh`. Ask one question at a time, wait for each answer.

## Questions
1. What does this project do and who uses it? → CLAUDE.md overview, ARCHITECTURE.md intro
2. Tech stack? (framework, db, auth, hosting) → ARCHITECTURE.md stack, CURRENT.md infra table
3. Who are the users/roles? → domain specs, glossary, CLAUDE.md roles
4. What are you building first? → CURRENT.md priorities
5. Compliance/data sensitivity? → CLAUDE.md rules, ARCHITECTURE.md data rules
6. What's already decided vs still open? → DECISIONS.md initial entries

## After interview

1. Write fully populated files (no placeholders — mark unknowns as 📋 Planned):
   - `CURRENT.md` — real stack, next priorities
   - `ARCHITECTURE.md` — stack, domain terms, data rules
   - `DECISIONS.md` — decided choices from Q6
   - `SESSIONS.md` — header only
   - `CLAUDE.md` — fill overview from Q1, rules from Q5

2. Create `docs/specs/<domain>.md` per major domain from Q3. Use `_template.md` structure, populate "Use cases by role", leave rest as `<!-- Populate as built -->`.

3. Show summary, confirm, then:
```bash
git add -A && git commit -m "init: project documentation and domain spec scaffolding"
```
