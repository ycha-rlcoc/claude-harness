# [Project Name]

[One-line description.]

## Read first
1. `CURRENT.md` — active phase, what's next
2. `ARCHITECTURE.md` — stack, structure, domain terms
3. `docs/specs/` — domain specs
4. `DECISIONS.md` — ADR log

## Diagnostic infra (keep permanently)
- `<ErrorBoundary>` at app root — on-screen stack + Copy button, stored at `window.__lastError`
- `<DevPanel>` behind `?debug=1` — nav stack, current screen, last 30 events
- Smoke tests for golden paths (Playwright)

## Bug-fix
1. Hypothesize first — 2–3 causes + distinguishing test before writing code.
2. Verify locally before deploying.
3. Commit each working state. Don't batch.
4. One bug per attempt. Ask for stack trace before reading source.

## Reading
- Grep before Read. Use offset/limit. Check ARCHITECTURE.md before re-deriving.

## Models
- Sonnet 4.6 default. Opus 4.7 for 3+ subsystem bugs, hard trade-offs, "is my approach wrong."
- Haiku 4.5 subagent: search, grep, reads, build/test, git log
- Sonnet subagent: multi-file research, code review, pattern-based writes
- Main thread: design calls, synthesis, actual edits, scope. Delegate impl to Sonnet after Opus call.

## Rules
- **Event journal:** For significant decisions (approach choice, library pick, scope deferral), append one line to `.claude/event-journal.log`: `YYYY-MM-DD | [type] | [decision + why]`.
- **Pre-execution intent:** Before destructive or hard-to-reverse actions (file deletes, force pushes, DB migrations, config overwrites), first append `PENDING: YYYY-MM-DD | [action] | [why]` to `.claude/event-journal.log`, then update to `DONE:` after.
- **Transcript:** After significant actions (file edits, commits, deploys, skill runs), append one line to `.claude/transcript.log`: `YYYY-MM-DD HH:MM | [action] | [target/result]`.
- Deploy: foreground only, wait for confirmation before next command.
- Tables: desktop table + mobile card. No `overflow-x-auto` for mobile.
- API routes: permission check server-side, not just UI gating.

## After a feature ships
Offer (substantive features only): write/update tests, update `docs/specs/`.

## Don't
- Speculative fixes without verification.
- Escalate scope without consent.
- Strip diagnostics same turn as shipping.
- Repeat same fix — fix #2 needs new information.
- Verbose responses. Short sentences. No preamble.
