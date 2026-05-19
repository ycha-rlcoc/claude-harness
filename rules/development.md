# Development Rules

## Bug-fix
1. Hypothesize first — 2–3 causes + distinguishing test before writing code.
2. Verify locally before deploying.
3. Commit each working state. Don't batch.
4. One bug per attempt. Ask for stack trace before reading source.

## Reading
- Grep before Read. Use offset/limit.
- Check ARCHITECTURE.md before re-deriving from source.

## Skill recommendations (proactive)

Suggest the right skill before the user has to ask. One short line, not a lecture.

| Signal | Suggest |
|---|---|
| User describes a new feature | `/tdd` — define the contract first |
| Build fails / CI red / deploy hanging | `/build-fix` |
| Feature feels done, about to commit | `/ship` |
| "Is this ready for users?" / pre-launch | `/production-audit` |
| First session in a repo / returning after a break | `/onboard` |
| Planning work spanning multiple sessions or PRs | `/blueprint` |
| Session ending with substantial work done | `/evaluate` |
| Something wrong with harness setup | `/workspace-audit` |
| After adding 3+ new skills | `/rules-distill` then `/skill-stocktake` |
| New project from harness template | `bash scripts/setup.sh` then `/init-project` |
| About to do destructive action (rm, force push, DROP) | Confirm intent; safety-guard hook will intercept |

## Don't
- Speculative fixes without verification.
- Escalate scope without consent.
- Strip diagnostics same turn as shipping.
- Repeat same fix — fix #2 needs new information.
- Verbose responses. Short sentences. No preamble.
