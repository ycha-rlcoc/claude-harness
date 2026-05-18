# /validate-phase

Read `CURRENT.md` to identify the active phase and its completion criteria. Check each gate.

## Gates to verify

1. **Tests** — run `testCommand` from `.claude/project.json`. Pass/fail.
2. **Specs** — for each domain touched this phase (infer from commits), check `docs/specs/<domain>.md` exists and has content beyond placeholder.
3. **Decisions logged** — any explicit trade-off made this phase should have a `DECISIONS.md` entry. Check recent entries match phase work.
4. **SESSIONS.md** — no `[narrative pending]` entries. All sessions summarized.
5. **Event journal** — `.claude/event-journal.log` has at least one entry dated this phase (if file exists).

## Output

Print a gate report:
```
/validate-phase — [Phase name]
✅ Tests: passed
✅ Specs: auth.md, billing.md updated
⚠️  Decisions: 2 trade-offs in commits not logged
✅ Sessions: all summarized
⚠️  Event journal: no entries this phase

2/5 gates need attention before marking phase complete.
```

Then ask: "Mark this phase complete and advance CURRENT.md to the next phase?" Apply only on yes.
