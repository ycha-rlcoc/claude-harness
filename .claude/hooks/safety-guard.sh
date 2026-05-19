#!/usr/bin/env python3
# PreToolUse hook — blocks destructive bash commands before execution.
# Bypass: add "# safety-guard: confirmed" comment to the command.
import json, re, sys

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

if data.get('tool_name') != 'Bash':
    sys.exit(0)

cmd = data.get('tool_input', {}).get('command', '')

if 'safety-guard: confirmed' in cmd:
    sys.exit(0)

PATTERNS = [
    (r'rm\s+-[rf]{1,2}\b', 'rm -rf'),
    (r'git\s+push\s+(--force|-f)\b', 'git push --force'),
    (r'git\s+reset\s+--hard\b', 'git reset --hard'),
    (r'git\s+checkout\s+\.\b', 'git checkout .'),
    (r'git\s+clean\s+-f\b', 'git clean -f'),
    (r'\bDROP\s+TABLE\b', 'DROP TABLE'),
    (r'\bDROP\s+DATABASE\b', 'DROP DATABASE'),
    (r'docker\s+system\s+prune\b', 'docker system prune'),
    (r'chmod\s+777\b', 'chmod 777'),
    (r'sudo\s+rm\b', 'sudo rm'),
    (r'kubectl\s+delete\b', 'kubectl delete'),
]

for pattern, label in PATTERNS:
    if re.search(pattern, cmd, re.IGNORECASE):
        print(json.dumps({
            "decision": "block",
            "reason": (
                f"safety-guard blocked: {label}\n\n"
                f"Command: {cmd}\n\n"
                f"To proceed, add '# safety-guard: confirmed' as a comment in the command."
            )
        }))
        sys.exit(0)

sys.exit(0)
