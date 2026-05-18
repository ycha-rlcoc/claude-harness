#!/bin/bash
PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATE_FILE="$PROJECT_DIR/.claude/session-state.json"

NOW=$(date +%s)
CURRENT_SHA=$(git rev-parse HEAD 2>/dev/null || echo "")

python3 - "$STATE_FILE" "$NOW" "$CURRENT_SHA" << 'EOF'
import json, os, sys
state_file, now, sha = sys.argv[1], int(sys.argv[2]), sys.argv[3]
state = json.load(open(state_file)) if os.path.exists(state_file) else {}
state['last_active'] = now
if not state.get('session_sha'):
    state['session_sha'] = sha
json.dump(state, open(state_file, 'w'))
EOF

# Record session boundary for /evaluate
BOUNDARY_FILE="$PROJECT_DIR/.claude/session-boundaries.log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
CURRENT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "none")
echo "$TIMESTAMP sha=$CURRENT_SHA" >> "$BOUNDARY_FILE"

# Append to durable transcript
TRANSCRIPT="$PROJECT_DIR/.claude/transcript.log"
CHANGED=$(git -C "$PROJECT_DIR" diff --name-only HEAD 2>/dev/null | head -5 | tr '\n' ',' | sed 's/,$//')
STAGED=$(git -C "$PROJECT_DIR" diff --cached --name-only 2>/dev/null | head -5 | tr '\n' ',' | sed 's/,$//')
FILES="${CHANGED:-${STAGED:-none}}"
echo "$TIMESTAMP | sha=$CURRENT_SHA | changed=$FILES" >> "$TRANSCRIPT"
