Deploy to production sequentially — tests first, then deploy. Never run in parallel or background.

Steps:

1. Read `.claude/project.json` to get `testCommand`, `deployCommand`, and `productionUrl`.

2. Run the `testCommand`. If tests fail, stop immediately and report which tests failed. Do NOT proceed to deploy.

3. If tests pass, state: "Tests passed. Deploying to production at [productionUrl]."

4. Run the `deployCommand` in the foreground using `run_in_background: false`. Wait for the full READY confirmation before considering the deploy complete.

5. Report the result:
   - Success: URL, build time, commit SHA
   - Failure: error output from the deploy, no automatic retry
