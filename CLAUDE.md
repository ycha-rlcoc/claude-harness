# [Project Name] — Claude Code Instructions

## Project overview

[Brief description of what this project does and why it exists.]

## Key files (read in this order)

1. `CURRENT.md` — what's done, what's next, active phase
2. `ARCHITECTURE.md` — stack, file structure, domain terms, conventions
3. `docs/specs/` — domain specs (auth, data models, key flows)
4. `DECISIONS.md` — ADR log, newest first

## Rules

- Follow all rules in `~/.claude/CLAUDE.md` (global).
- **Never run the deploy command in the background or in parallel.** Always run it
  in the foreground and wait for success confirmation before the next command.
- **All tables use a desktop table + mobile card pattern.** Never use horizontal
  scroll (`overflow-x-auto`) as the primary mobile strategy for data tables.
- **Permission check in every API route**, not just UI gating.

## After completing a feature

When a feature feels complete (meaningful functionality shipped and committed — not a
typo fix or style tweak), proactively offer both of the following without waiting to be asked:

1. **Write tests** — offer to write or update tests covering the new behavior. Run
   the test command to confirm existing tests still pass.

2. **Update specs** — offer to update or create the relevant domain spec in `docs/specs/`.
   Update the **What it does**, **Business rules**, and **Changelog** sections.

Use judgment — don't offer this after minor fixes, only after substantive features.

## Token efficiency (apply every session)

- Sonnet 4.6 — default for all execution
- Opus 4.7 — only for multi-system architecture, security review, hard tradeoff calls
- Haiku 4.5 via Explore subagent — file search, grep, "find all X in codebase"
