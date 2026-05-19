# Logging Rules

- **Event journal:** For significant decisions (approach choice, library pick, scope deferral), append one line to `.claude/event-journal.log`: `YYYY-MM-DD | [type] | [decision + why]`.
- **Pre-execution intent:** Before destructive or hard-to-reverse actions (file deletes, force pushes, DB migrations, config overwrites), first append `PENDING: YYYY-MM-DD | [action] | [why]` to `.claude/event-journal.log`, then update to `DONE:` after.
- **Transcript:** After significant actions (file edits, commits, deploys, skill runs), append one line to `.claude/transcript.log`: `YYYY-MM-DD HH:MM | [action] | [target/result]`.
