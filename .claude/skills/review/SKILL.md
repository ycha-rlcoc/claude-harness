# /review

Code review on recent changes. Default: last commit. Pass a commit range or PR number to override.

## Steps

1. **Get the diff**
```bash
git diff HEAD~1 HEAD                    # default
git diff <base>..<head>                 # range
gh pr diff <number>                     # PR
```

2. **Read context** — for each changed file, read only the surrounding function/class (not the whole file). Check `ARCHITECTURE.md` for conventions. Do NOT read the entire codebase.

3. **Review across four dimensions:**

   **Correctness** — logic errors, off-by-one, null/undefined handling, async issues, wrong assumptions about data shape.

   **Security** — input validation, auth checks, SQL injection, XSS, secrets in code, insecure defaults. Flag severity: 🔴 critical / 🟡 medium / 🟢 low.

   **Conventions** — does it match patterns in `ARCHITECTURE.md` and surrounding code? Naming, structure, error handling style.

   **Test coverage** — are the changed paths covered? Note gaps without writing tests (use `/test-write` for that).

4. **Report:**
```
/review — <commit or PR>
Files: N changed

🔴 Critical (must fix before merge)
- [file:line] [issue] — [why it matters]

🟡 Medium (should fix)
- [file:line] [issue]

🟢 Low / style (optional)
- [file:line] [suggestion]

✅ Looks good
- [what's done well — 1-3 things]

Verdict: APPROVE / REQUEST CHANGES / NEEDS DISCUSSION
```

5. For each 🔴 issue, ask: "Fix this now?" Apply on yes, skip on no.

## What this skill does NOT do
- Does not rewrite code unprompted — flags issues only
- Does not review files not in the diff
- Does not run tests (use `/test-write` or `/deploy`)
