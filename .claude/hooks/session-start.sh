#!/bin/bash
# Runs on every UserPromptSubmit.
# Detects new session (gap > 30 min), writes git facts to SESSIONS.md,
# outputs reminder so Claude auto-fills the narrative summary.
PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATE_FILE="$PROJECT_DIR/.claude/session-state.json"
SESSIONS_FILE="$PROJECT_DIR/SESSIONS.md"
NOW=$(date +%s)
THRESHOLD=1800  # 30 minutes

python3 - "$STATE_FILE" "$SESSIONS_FILE" "$NOW" "$THRESHOLD" "$PROJECT_DIR" << 'EOF'
import json, os, subprocess, sys
from datetime import datetime

state_file, sessions_file, now, threshold, project_dir = \
    sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), sys.argv[5]

def git(cmd):
    return subprocess.getoutput(f'git -C {project_dir} {cmd}')

# Initialize state on first run
if not os.path.exists(state_file):
    sha = git('rev-parse HEAD')
    json.dump({'last_active': now, 'session_sha': sha}, open(state_file, 'w'))
    sys.exit(0)

state = json.load(open(state_file))
gap = now - state.get('last_active', now)

if gap > threshold:
    # New session — write previous session facts to SESSIONS.md
    session_sha = state.get('session_sha', '')
    current_sha = git('rev-parse HEAD')
    date_str = datetime.fromtimestamp(state['last_active']).strftime('%Y-%m-%d %H:%M')
    branch = git('branch --show-current')

    if session_sha and session_sha != current_sha:
        commits = git(f'log --oneline {session_sha}..HEAD')
    else:
        commits = git('log --oneline -5')

    commit_lines = '\n'.join(f'  {l}' for l in commits.splitlines() if l) or '  (none)'

    entry = (
        f"\n## {date_str} — [narrative pending]\n"
        f"Branch: {branch}\n"
        f"Commits:\n{commit_lines}\n"
        f"<!-- Claude: replace '[narrative pending]' with 2-3 line summary: "
        f"session goal, key decisions, key prompts that drove changes -->\n"
    )

    with open(sessions_file, 'a') as f:
        f.write(entry)

    # Reset session state
    json.dump({'last_active': now, 'session_sha': current_sha}, open(state_file, 'w'))

    # Inject reminder into Claude context
    print(
        f"SESSION SUMMARY NEEDED: {gap // 60} min gap detected. "
        f"A new entry was added to SESSIONS.md for {date_str} with git facts. "
        f"Before responding to the user, complete the SESSIONS.md entry: "
        f"replace '[narrative pending]' with a 2-3 line summary — "
        f"session goal, key decisions made, key prompts that drove changes. "
        f"Then respond normally."
    )
else:
    # Same session — update heartbeat only
    state['last_active'] = now
    json.dump(state, open(state_file, 'w'))
EOF
