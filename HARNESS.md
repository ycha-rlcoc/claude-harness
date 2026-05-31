# Harness Usage Guide

## New project

**1. Clone as template:**
```bash
gh repo create my-project --template ycha-rlcoc/claude-harness --private --clone
cd my-project
```

**2. Run setup:**
```bash
bash scripts/setup.sh
```
Prompts for project name, URL, test/deploy commands. Writes `settings.json`, installs post-commit hook, creates `docs/` dirs, merges missing sections into existing files. Also syncs any skills added to the harness after the template snapshot — so you always start with the full skill set.

**3. Manual steps (prompted by setup.sh):**
- Reload VSCode: `Cmd+Shift+P` → Developer: Reload Window
- `git add -A && git commit -m "init: project from claude-harness"`
- `gh repo create my-project --private --source=. --push`

**4. Run `/init-project` in Claude Code:**
Interviews you (6 questions), populates `CURRENT.md`, `ARCHITECTURE.md`, `DECISIONS.md`, and creates starter domain specs.

**5. Enable parallel subagents (optional):**
```bash
cp .env.example .env   # add ANTHROPIC_API_KEY
pip install anthropic
```

---

## Existing project

**1. Copy harness files into your project:**
```bash
cp -r path/to/claude-harness/.claude ./
cp -r path/to/claude-harness/scripts ./
cp -r path/to/claude-harness/templates ./
cp path/to/claude-harness/.env.example ./
```

**2. Run setup (safe — merges, never overwrites):**
```bash
bash scripts/setup.sh
```
Merges missing `##` sections into existing docs, adds session hooks to existing `settings.json`, installs post-commit hook.

**3. Reload VSCode.** Review `<!-- Merged from harness -->` comments and clean up anything that doesn't fit.

**4. Run `/init-project`** to fill doc gaps, or populate manually.

---

## Day-to-day commands

| Moment | Command |
|---|---|
| After shipping a feature | `/ship` |
| End of session | `/evaluate` |
| Before marking a phase done | `/validate-phase` |
| After editing a skill file | `/test-skill <name>` |
| Added skills to harness | `bash sync-skills.sh` + reload VSCode |

---

## Syncing skills to other projects

```bash
# From workspace root — syncs to workspace .claude/
bash sync-skills.sh

# Sync to a specific project
bash claude-harness/scripts/sync-skills.sh path/to/project/
```

Only adds/updates — never removes. Reports what changed.

---

## /ship sequence

```
Phase 1 (parallel): /review + /security-review
         ↓ fix any critical issues
Phase 2 (parallel): /test-write + /spec-update
         ↓
         /deploy
```

With `ANTHROPIC_API_KEY` set, phases run as parallel API subagents:
```bash
python3 scripts/ship.py
```

Without API key, `/ship` runs sequentially in the current Claude Code session.

Run any skill as a standalone API subagent:
```bash
python3 scripts/subagent.py review
python3 scripts/subagent.py security-review --model sonnet
```

---

## Contributing back to the harness

The harness compounds in value when every project feeds learnings back into it. The loop:

```
Session ends → /evaluate → identify universal learnings
                         → update ~/.claude/CLAUDE.md (global rules)
                         → PR to ycha-rlcoc/claude-harness (skills/rules/templates)
                         → merge → bash sync-skills.sh in workspace
```

**What belongs in the harness:**
- Rules that apply to any project — auth patterns, testing discipline, output conventions
- Skill improvements — a check you wish `/security-review` had run, a step `/evaluate` missed
- Templates — CI pipelines, config files, setup patterns with gotchas baked in as comments

**What stays in the project:**
- Stack-specific rules (platform deploy quirks, component patterns, compliance requirements)
- Project-specific docs (`CURRENT.md`, `DECISIONS.md`, `docs/specs/`)

**After merging a harness PR:**
```bash
bash sync-skills.sh   # pulls updated skills into all workspace projects
```

**`~/.claude/CLAUDE.md`** — create this file to hold global rules that apply across every project regardless of harness version. The harness `rules/` directory is per-project; `~/.claude/CLAUDE.md` is per-machine. Good candidates: model selection habits, output style preferences, universal security rules.

---

## All skills

| Skill | Purpose |
|---|---|
| `/init-project` | Interview → populate all docs + domain specs |
| `/ship` | Full quality gate: review → security → tests → specs |
| `/deploy` | Run tests then deploy, foreground only |
| `/evaluate` | Session retrospective, writes to `docs/evaluations/` |
| `/review` | Code review on last commit or PR |
| `/security-review` | OWASP scan on changed code |
| `/test-write` | Write tests for last commit's changes |
| `/spec-update` | Sync `docs/specs/` from recent commits |
| `/validate-phase` | Gate check before advancing to next phase |
| `/test-skill <name>` | Regression check a skill against its golden spec |
