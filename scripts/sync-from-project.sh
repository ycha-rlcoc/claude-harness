#!/bin/bash
# Syncs harness files from a project directory into this harness repo.
# Run from inside the claude-harness directory.
# Usage: bash scripts/sync-from-project.sh /path/to/project

set -e

PROJECT="${1:?Usage: bash scripts/sync-from-project.sh /path/to/project}"
HARNESS="$(git rev-parse --show-toplevel)"

echo "Syncing harness files from: $PROJECT"

rsync -av --relative \
  "$PROJECT/.claude/settings.json" \
  "$PROJECT/.claude/hooks/session-stop.sh" \
  "$PROJECT/.claude/hooks/session-start.sh" \
  "$PROJECT/.claude/skills/evaluate/SKILL.md" \
  "$PROJECT/.claude/skills/deploy/SKILL.md" \
  "$HARNESS/" 2>/dev/null || true

# Trim project-specific lines from settings.json (keep only portable hooks)
echo "Files synced. Review changes with: git diff"
echo "Then: git add -A && git commit -m 'chore: sync from project' && git push"
