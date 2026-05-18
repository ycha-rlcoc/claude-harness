# /deploy — Sequential Deploy Skill

**Trigger:** User types `/deploy` or `/deploy prod`

**Purpose:** Run tests, then deploy to production in a single sequential operation.
Prevents queued deploys caused by running the deploy command in parallel or background.

---

## Steps (in strict order — stop on any failure)

### 1. Read project config
```bash
cat .claude/project.json
```
Extract `testCommand`, `deployCommand`, and `productionUrl`.

### 2. Run tests
Run the `testCommand` from `project.json` (default: `npm run test:coverage`).

If tests fail: stop immediately, report which tests failed, do NOT deploy.
If tests pass: continue.

### 3. State intent
> "Tests passed. Deploying to production at `[productionUrl]`."

### 4. Deploy (foreground only)
Run the `deployCommand` from `project.json` (default: `vercel --prod`).

**Never use `run_in_background: true`** for this command.
Wait for full output and READY confirmation before considering deploy complete.

### 5. Report result
```
✅ Deployed to production
URL: [productionUrl]
Build: Xs | Commit: [short sha]
```

On failure: show the error, do not retry automatically.

---

## What this skill does NOT do
- Does not run E2E or integration tests (too slow for every deploy)
- Does not push to GitHub first (do that separately)
- Does not prompt for confirmation — tests passing is the gate
