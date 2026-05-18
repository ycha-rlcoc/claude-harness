Perform a session evaluation by analyzing what happened since the last evaluation boundary.

Steps:

1. Read `.claude/session-boundaries.log` to find the last session end timestamp. If missing, use the last 24 hours. Skip if the session had fewer than 3 commits and less than 15 minutes of activity.

2. Run `git log --oneline --since="<last boundary timestamp>"` to see what was committed this session.

3. Analyze across four dimensions using the current conversation context and git log (do NOT read all source files):

   **Friction points** — what required multiple attempts, backtracking, or a fix that a CLAUDE.md rule would have prevented.

   **New patterns established** — conventions or decisions that emerged and should be codified in CLAUDE.md or a domain spec so future sessions don't re-derive them.

   **Missing context** — things I had to look up that a spec or doc should have answered in one read.

   **Candidate harness features** — things I did manually that could be automated as a hook, skill, or command.

4. Write a report to `docs/evaluations/YYYY-MM-DD.md` (append if the file exists today) using this format:

```
# Session Evaluation — YYYY-MM-DD HH:MM UTC

**Session window:** [start] → [end]
**Commits:** [count] — [brief description]

---

## Friction points
- [What happened + what would prevent it next time]

## New patterns to codify
- [Pattern] → Recommended: add to CLAUDE.md / update [spec]

## Missing context
- [What I had to look up] → Recommended: add to [file]

## Candidate harness features
| What I did manually | Automation | Effort | Recommend |
|---------------------|------------|--------|-----------|

---

## Immediate actions (do now)
1. [High confidence, low effort change]

## Consider for harness
- **[Feature]:** [What, why, tradeoff]

## Defer
- [Idea] — [Why not now]
```

5. Print a summary:
```
## /evaluate complete — docs/evaluations/YYYY-MM-DD.md
🔴 Friction: N  🟡 Patterns: N  🟢 Context gaps: N  ⚡ Harness: N
Top action: [single most important thing]
```

6. Ask: "Want me to apply the immediate actions now?"
