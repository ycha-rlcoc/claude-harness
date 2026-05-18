# /evaluate — Session Evaluation Skill

**Trigger:** User types `/evaluate`

**Purpose:** Reflect on the current session (or since the last evaluation) and produce
a structured analysis of what worked, what caused friction, and what should be codified,
improved, or built into the harness.

---

## When invoked, do the following steps in order:

### 1. Determine the session window

Read `.claude/session-boundaries.log`. The last entry is the end of the previous session.
Everything committed or discussed since that timestamp is "this session."

If the file doesn't exist or is empty, use the last 24 hours as the default window.

### 2. Gather context (read these files)

- `.claude/session-boundaries.log` — session boundary timestamps
- `.claude/project.json` — project name and config
- `CLAUDE.md` — current behavioral rules
- `docs/specs/` — list all spec files (just filenames, not full content)
- `.claude/skills/` — list existing skills
- Run: `git log --oneline --since="<last boundary timestamp>"` — what was committed this session

Do NOT read all source files. Use the git log and conversation context already in your window.

### 3. Analyze the session across four dimensions

**A. Friction points**
What required multiple attempts, backtracking, or fixing? What caused a bug that a rule
in CLAUDE.md would have prevented? What was unclear that a spec would have clarified?

**B. New patterns established**
What conventions were decided or patterns emerged that should be codified so future
sessions don't re-derive them? These become CLAUDE.md rules or spec entries.

**C. Missing context**
What did I need to look up or re-derive that a spec or doc should have answered in
one read? What question did you have to answer twice?

**D. Candidate harness features**
What did I do manually that could be automated as a hook, tool, or skill? What friction
point is structural rather than solvable by documentation?

### 4. Write the evaluation report

Write to: `docs/evaluations/YYYY-MM-DD.md` (use today's date).
If a file for today already exists, append a new `---` section.

```markdown
# Session Evaluation — YYYY-MM-DD HH:MM UTC

**Session window:** [start] → [end]
**Commits this session:** [count] — [brief description]

---

## Friction points
- [What + what would fix it]

## New patterns to codify
- [Pattern] → **Recommended action:** Add to CLAUDE.md / update [spec file]

## Missing context
- [What I had to look up] → **Recommended action:** Add to [spec/doc file]

## Candidate harness features

| What I did manually | Automation potential | Effort | Recommendation |
|---------------------|----------------------|--------|----------------|
| [description] | [hook/skill/tool] | Low/Med/High | Build / Defer / Skip |

---

## Immediate actions (high confidence, low effort)
1. [Action]

## Consider building into harness
- **[Feature]:** [What, why, tradeoff]

## Defer
- [Idea] — [Why]
```

### 5. Display a summary in the terminal

After writing the file, print:
```
## /evaluate complete — docs/evaluations/YYYY-MM-DD.md

Session: [N commits] | [timespan]
🔴 Friction: [count] | 🟡 Patterns: [count] | 🟢 Context gaps: [count] | ⚡ Harness: [count]
Top action: [single most important thing]
```

### 6. Offer to apply immediate actions

Ask: "Want me to apply the immediate actions now?"
If yes — apply them. If no — leave the report for later review.

---

## What this skill does NOT do
- Does not automatically modify files without asking
- Does not re-read all source files — uses git log and conversation context
- Does not run if the session was trivial (< 3 commits and < 15 minutes)
