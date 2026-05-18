# /deploy

Sequential test → deploy. Stop on any failure.

1. Read `.claude/project.json` → `testCommand`, `deployCommand`, `productionUrl`.
2. Run `testCommand`. Fail: report and stop. Do not deploy.
3. Run `deployCommand` **foreground only** (never `run_in_background: true`). Wait for READY.
4. Report:
```
✅ Deployed — [productionUrl]
Build: Xs | Commit: [sha]
```
On failure: show error, do not retry.
