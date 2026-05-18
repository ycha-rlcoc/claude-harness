# Agent Instructions

Primary instructions are in `CLAUDE.md`. This file provides compatibility for non-Claude coding agents (Gemini CLI, Codex, Copilot, etc.).

## Read first
1. `CURRENT.md` — active phase, what's next
2. `ARCHITECTURE.md` — stack, structure, domain terms
3. `docs/specs/` — domain specs for active work
4. `DECISIONS.md` — ADR log, newest first

## Key rules
- Hypothesize before coding. Verify locally before deploying.
- Commit each working state. One bug per attempt.
- Grep before Read. Check ARCHITECTURE.md before re-deriving.
- Terse responses. No preamble.
- Deploy foreground only — never background or parallel.
- Permission check server-side on every API route.
