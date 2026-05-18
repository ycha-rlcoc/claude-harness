# /init-project — Project Initialization Skill

**Trigger:** User types `/init-project`

**Purpose:** Interview the user about their new project and generate populated,
ready-to-use content for all four project documentation files: `CURRENT.md`,
`ARCHITECTURE.md`, `DECISIONS.md`, and `SESSIONS.md`. Also scaffolds the first
domain specs based on the project's structure.

Run this once after `bash scripts/setup.sh` on a fresh harness clone.

---

## Interview sequence

Ask these questions one at a time. Wait for each answer before continuing.
Do not ask all at once — this is a conversation, not a form.

### Question 1 — What does this project do?
> "In one or two sentences, what does this project do and who uses it?"

Use the answer to write the CLAUDE.md overview and ARCHITECTURE.md intro.

### Question 2 — What's the tech stack?
> "What are you building with? (framework, database, auth, deployment, etc. — just
> list what you know so far, even if incomplete)"

Use the answer to populate the ARCHITECTURE.md stack table and CURRENT.md
infrastructure table. Mark unknowns as 📋 Planned.

### Question 3 — Who are the users and what roles exist?
> "Who uses this app, and do they have different roles with different levels of access?
> (e.g. admin, customer, viewer — describe each in one sentence)"

Use the answer to:
- Identify the initial domain specs to create
- Populate the domain terms glossary in ARCHITECTURE.md
- Set up the CLAUDE.md user roles section if applicable

### Question 4 — What are you building first?
> "What's the first thing you want to build or what phase are you in?
> What's the most important thing to ship in the next week or two?"

Use the answer to populate CURRENT.md next priorities.

### Question 5 — Any compliance, legal, or data sensitivity constraints?
> "Does this project handle sensitive data, have regulatory requirements, or have
> hard rules about what data can appear where? (or 'none' if not applicable)"

Use the answer to populate the CLAUDE.md rules section and ARCHITECTURE.md
sensitive data rules.

### Question 6 — What's already decided about the stack?
> "Have you already decided on anything — framework, hosting, database?
> What's still open?"

Use the answer to populate the initial DECISIONS.md entry (first decisions made).

---

## After the interview

### 1. Generate the files

Using the answers, write fully populated versions of:

- `CURRENT.md` — infrastructure table (with real stack), next priorities from Q4
- `ARCHITECTURE.md` — stack section, conventions from Q2/Q5, domain terms from Q3
- `DECISIONS.md` — initial entries for any already-decided choices from Q6
- `SESSIONS.md` — header only (hook will populate sessions automatically)
- Update `CLAUDE.md` — fill in project overview and any rules from Q5

Do not leave placeholder text — use the actual answers. If something is unknown,
mark it as 📋 Planned in tables or omit the section.

### 2. Scaffold initial domain specs

Based on Q3 (roles and domains), create starter spec files in `docs/specs/`:
- One spec per major domain (e.g. `auth.md`, `user-management.md`, `billing.md`)
- Use the spec template from `docs/specs/_template.md`
- Populate the "Use cases by role" section from Q3
- Leave other sections with placeholder text and a comment like:
  `<!-- Populate as this domain gets built -->`

### 3. Confirm and commit

Show a summary of what was created. Ask:
> "Does this look right? I can adjust anything before we commit."

If confirmed, run:
```bash
git add -A
git commit -m "init: project documentation and domain spec scaffolding"
```

---

## What this skill does NOT do

- Does not write any application code
- Does not make technology decisions — it documents what you've already decided
- Does not replace reading the templates — the templates explain each section in detail
- Does not need to be run again — `/evaluate` handles ongoing documentation updates
