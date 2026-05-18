# claude-harness

A portable Claude Code project harness. Clone this as the starting point for any new project to get session tracking, domain specs, evaluation tooling, and deployment skills pre-configured.

## What's included

| File | Purpose |
|------|---------|
| `.claude/settings.json` | Hooks: post-commit test reminder, session boundary logging, session start |
| `.claude/hooks/session-stop.sh` | Records session boundaries for `/evaluate`; updates session state |
| `.claude/hooks/session-start.sh` | Detects new sessions, writes git facts to SESSIONS.md |
| `.claude/skills/evaluate/SKILL.md` | `/evaluate` — session reflection skill |
| `.claude/skills/deploy/SKILL.md` | `/deploy` — sequential test + deploy skill |
| `.claude/project.json` | Project config (name, URLs, commands) |
| `CLAUDE.md` | Portable behavioral rules for Claude |
| `docs/specs/_template.md` | Domain spec format template |
| `docs/evaluations/` | Where `/evaluate` writes session reports |
| `scripts/setup.sh` | One-time setup script after cloning |

## Starting a new project

```bash
# Clone as template
gh repo create my-new-project --template ycha-rlcoc/claude-harness --private --clone
cd my-new-project

# Configure for your project
bash scripts/setup.sh

# Start building
```

## Skills

**`/evaluate`** — Run at the end of any substantial work session. Analyzes friction
points, new patterns, missing docs, and candidate harness improvements. Writes a report
to `docs/evaluations/YYYY-MM-DD.md` and offers to apply immediate actions.

**`/deploy`** — Runs your test command, then deploys to production sequentially.
Prevents the queued-deploy problem. Reads config from `.claude/project.json`.

## Syncing improvements back

When you improve the harness in one project and want to bring changes to another:

```bash
# Copy specific files from the source project
cp source-project/.claude/skills/new-skill/SKILL.md \
   target-project/.claude/skills/new-skill/SKILL.md

# Or update manually — all files are plain text
```

## What to add per project

After running `setup.sh`, you should create:
- `CURRENT.md` — what's done, what's next
- `ARCHITECTURE.md` — stack, conventions, domain terms
- `DECISIONS.md` — ADR log
- `SESSIONS.md` — session log (auto-populated by the session-start hook)
- Domain specs in `docs/specs/` — copy `_template.md` for each domain
