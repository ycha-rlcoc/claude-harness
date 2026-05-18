# Session Log

<!--
PURPOSE: A running log of what happened in each Claude Code session.
Auto-populated by the session-start hook — Claude fills in the narrative
before responding to the first message of each new session.

WHY IT EXISTS: Gives new sessions instant context about recent work without
reading git logs or asking "what did we do last time?"

HOW IT WORKS:
- The session-start hook detects a 30+ min gap since last activity
- It writes a new entry with the date, branch, and git commits
- Claude fills in the [narrative pending] section with a 2-3 line summary
- You can also add your own notes to entries

DO NOT DELETE OLD ENTRIES — they're the project's working memory.
-->

---

<!-- Entries are added automatically below. Example format:

## 2026-05-18 — [narrative pending]

Branch: main
Commits:
  abc1234 feat: add user authentication
  def5678 fix: resolve login redirect bug

Claude fills in: what the session goal was, key decisions made, and key prompts
that drove the main changes.

-->
