#!/bin/bash
# Sync commands and skills from this harness to a target project's .claude/
# Usage: bash scripts/sync-skills.sh [target-dir]
# Default target: parent directory (if it has a .claude/)

HARNESS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${1:-$(dirname "$HARNESS_DIR")}"
TARGET_CLAUDE="$TARGET_DIR/.claude"

if [ ! -d "$TARGET_CLAUDE" ]; then
  echo "No .claude/ found at $TARGET_DIR — pass a target directory as argument."
  exit 1
fi

echo "Syncing skills: $HARNESS_DIR → $TARGET_DIR"
echo ""

mkdir -p "$TARGET_CLAUDE/commands" "$TARGET_CLAUDE/skills"

ADDED=0
UPDATED=0
SKIPPED=0

# Sync commands
for src in "$HARNESS_DIR/.claude/commands/"*.md; do
  name=$(basename "$src")
  dest="$TARGET_CLAUDE/commands/$name"
  if [ ! -f "$dest" ]; then
    cp "$src" "$dest"
    echo "  + commands/$name"
    ADDED=$((ADDED + 1))
  elif ! diff -q "$src" "$dest" > /dev/null 2>&1; then
    cp "$src" "$dest"
    echo "  ~ commands/$name (updated)"
    UPDATED=$((UPDATED + 1))
  else
    SKIPPED=$((SKIPPED + 1))
  fi
done

# Sync skills
for src_dir in "$HARNESS_DIR/.claude/skills/"/*/; do
  name=$(basename "$src_dir")
  dest_dir="$TARGET_CLAUDE/skills/$name"
  dest="$dest_dir/SKILL.md"
  src="$src_dir/SKILL.md"
  mkdir -p "$dest_dir"
  if [ ! -f "$dest" ]; then
    cp "$src" "$dest"
    echo "  + skills/$name/SKILL.md"
    ADDED=$((ADDED + 1))
  elif ! diff -q "$src" "$dest" > /dev/null 2>&1; then
    cp "$src" "$dest"
    echo "  ~ skills/$name/SKILL.md (updated)"
    UPDATED=$((UPDATED + 1))
  else
    SKIPPED=$((SKIPPED + 1))
  fi
done

echo ""
echo "✓ $ADDED added, $UPDATED updated, $SKIPPED already up to date"
echo "  Reload VSCode window to activate new skills: Cmd+Shift+P → Developer: Reload Window"
