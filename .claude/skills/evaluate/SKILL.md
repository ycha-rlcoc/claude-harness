# /evaluate

Read `.claude/session-boundaries.log` for session window (default: last 24h). Skip if <3 commits and <15 min.

## Steps

1. **Gather:** `git log --oneline --since=<last boundary>`. Don't read source files.

2. **Analyze:**
   - Friction — what required multiple attempts; what CLAUDE.md rule would have prevented it
   - Patterns — conventions to codify in CLAUDE.md or specs
   - Missing context — what had to be looked up that a doc should answer
   - Harness candidates — manual work that could be a hook/skill

3. **Write** `docs/evaluations/YYYY-MM-DD.md` (append if exists):
```
# Session Evaluation — YYYY-MM-DD HH:MM UTC
Session: [start] → [end] | [N commits]
---
## Friction
- [what + fix]
## Patterns to codify
- [pattern] → add to [file]
## Missing context
- [what] → add to [file]
## Harness candidates
| Manual work | Automation | Effort | Recommend |
|-------------|------------|--------|-----------|
---
## Immediate actions
1. [action]
## Consider for harness
- [feature]: [why]
## Defer
- [idea] — [why not now]
```

4. **Print:**
```
/evaluate complete — docs/evaluations/YYYY-MM-DD.md
🔴 Friction: N | 🟡 Patterns: N | 🟢 Context gaps: N | ⚡ Harness: N
Top action: [most important thing]
```

5. **Present immediate actions one at a time:**
> Action [N]/[total]: [what] | File: [path] | Why: [one sentence] — Apply? (yes/no/stop)

Apply on yes, skip on no, stop on stop. Summarize applied vs skipped.
