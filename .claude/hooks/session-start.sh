#!/bin/bash
PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATE_FILE="$PROJECT_DIR/.claude/session-state.json"
SESSIONS_FILE="$PROJECT_DIR/SESSIONS.md"
NOW=$(date +%s)
THRESHOLD=1800

python3 - "$STATE_FILE" "$SESSIONS_FILE" "$NOW" "$THRESHOLD" "$PROJECT_DIR" << 'EOF'
import json, os, subprocess, sys
from datetime import datetime

state_file, sessions_file, now, threshold, project_dir = \
    sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), sys.argv[5]

def git(cmd):
    return subprocess.getoutput(f'git -C {project_dir} {cmd}')

if not os.path.exists(state_file):
    sha = git('rev-parse HEAD')
    json.dump({'last_active': now, 'session_sha': sha}, open(state_file, 'w'))
    sys.exit(0)

state = json.load(open(state_file))
gap = now - state.get('last_active', now)

if gap > threshold:
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

    # Archive entries older than 30 days
    archive_file = os.path.join(project_dir, 'docs', 'sessions-archive.md')
    if os.path.exists(sessions_file):
        cutoff = now - (30 * 86400)
        with open(sessions_file, 'r') as f:
            content = f.read()
        sections = content.split('\n## ')
        header = sections[0]
        entries = ['\n## ' + s for s in sections[1:]]
        recent, old = [], []
        for e in entries:
            first_line = e.strip().splitlines()[0] if e.strip() else ''
            try:
                date_part = first_line.lstrip('#').lstrip().split('—')[0].strip()
                ts = datetime.strptime(date_part, '%Y-%m-%d %H:%M').timestamp()
                (old if ts < cutoff else recent).append(e)
            except Exception:
                recent.append(e)
        if old:
            os.makedirs(os.path.dirname(archive_file), exist_ok=True)
            with open(archive_file, 'a') as f:
                f.write(''.join(old))
            with open(sessions_file, 'w') as f:
                f.write(header + ''.join(recent))

    json.dump({'last_active': now, 'session_sha': current_sha}, open(state_file, 'w'))

    # Build context injection
    context_parts = [
        f"SESSION SUMMARY NEEDED: {gap // 60} min gap detected. "
        f"A new entry was added to SESSIONS.md for {date_str}. "
        f"Fill in '[narrative pending]' before responding: session goal, key decisions, key prompts. "
        f"Then respond normally."
    ]

    # Inject recent decisions
    decisions_file = os.path.join(project_dir, 'DECISIONS.md')
    if os.path.exists(decisions_file):
        with open(decisions_file, 'r') as f:
            dcontent = f.read()
        recent_decisions = []
        for block in dcontent.split('\n## ')[1:4]:
            first_line = block.strip().splitlines()[0] if block.strip() else ''
            if first_line:
                recent_decisions.append(f'  - {first_line}')
        if recent_decisions:
            context_parts.append('Recent decisions:\n' + '\n'.join(recent_decisions))

    # Inject active spec hint from CURRENT.md
    current_file = os.path.join(project_dir, 'CURRENT.md')
    specs_dir = os.path.join(project_dir, 'docs', 'specs')
    if os.path.exists(current_file) and os.path.isdir(specs_dir):
        with open(current_file, 'r') as f:
            current_content = f.read().lower()
        specs = [f for f in os.listdir(specs_dir) if f.endswith('.md') and not f.startswith('_')]
        relevant = [s for s in specs if s.replace('.md', '').replace('-', ' ') in current_content]
        if relevant:
            context_parts.append(f'Active specs (consider reading): {", ".join(relevant)}')

    print('\n'.join(context_parts))

else:
    state['last_active'] = now
    json.dump(state, open(state_file, 'w'))
EOF
