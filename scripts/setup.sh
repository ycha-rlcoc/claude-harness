#!/bin/bash
# Run once after cloning claude-harness to configure a new project.
# Usage: bash scripts/setup.sh

set -e

echo "Claude Harness Setup"
echo "===================="
echo ""

read -p "Project name: " PROJECT_NAME
read -p "Production URL (e.g. https://my-app.vercel.app): " PRODUCTION_URL
read -p "Test command [npm run test:coverage]: " TEST_COMMAND
TEST_COMMAND=${TEST_COMMAND:-npm run test:coverage}
read -p "Deploy command [vercel --prod]: " DEPLOY_COMMAND
DEPLOY_COMMAND=${DEPLOY_COMMAND:-vercel --prod}

echo ""
echo "Setting up..."

# Write project config
cat > .claude/project.json << EOF
{
  "projectName": "$PROJECT_NAME",
  "productionUrl": "$PRODUCTION_URL",
  "testCommand": "$TEST_COMMAND",
  "deployCommand": "$DEPLOY_COMMAND"
}
EOF
echo "✓ .claude/project.json"

# Write or merge settings.json (hooks)
python3 - << 'EOF'
import json, os

path = '.claude/settings.json'
stop_hook = {"type": "command", "command": "bash \"$(git rev-parse --show-toplevel)/.claude/hooks/session-stop.sh\""}
start_hook = {"type": "command", "command": "bash \"$(git rev-parse --show-toplevel)/.claude/hooks/session-start.sh\""}

if os.path.exists(path):
    with open(path) as f:
        settings = json.load(f)
    hooks = settings.setdefault('hooks', {})

    # Merge Stop hook if not present
    stop_hooks = hooks.setdefault('Stop', [{'hooks': []}])
    existing_stop = [h.get('command','') for s in stop_hooks for h in s.get('hooks',[])]
    if not any('session-stop' in c for c in existing_stop):
        stop_hooks[0]['hooks'].append(stop_hook)

    # Merge UserPromptSubmit hook if not present
    submit_hooks = hooks.setdefault('UserPromptSubmit', [{'hooks': []}])
    existing_submit = [h.get('command','') for s in submit_hooks for h in s.get('hooks',[])]
    if not any('session-start' in c for c in existing_submit):
        submit_hooks[0]['hooks'].append(start_hook)

    with open(path, 'w') as f:
        json.dump(settings, f, indent=2)
    print("✓ .claude/settings.json (merged)")
else:
    settings = {
        "hooks": {
            "Stop": [{"hooks": [stop_hook]}],
            "UserPromptSubmit": [{"hooks": [start_hook]}]
        }
    }
    with open(path, 'w') as f:
        json.dump(settings, f, indent=2)
    print("✓ .claude/settings.json (created)")
EOF

# Update CLAUDE.md header
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/" CLAUDE.md 2>/dev/null || \
sed -i "s/\[Project Name\]/$PROJECT_NAME/" CLAUDE.md

# Merge missing sections into CLAUDE.md and doc templates
python3 - << 'EOF'
import os, re

def get_sections(text):
    """Return dict of {heading: full_block} for each ## section."""
    blocks = re.split(r'\n(?=## )', text)
    sections = {}
    for block in blocks[1:]:
        heading = block.split('\n')[0].strip()
        sections[heading] = block
    return sections

def merge_md(source_path, target_path, label):
    if not os.path.exists(source_path) or not os.path.exists(target_path):
        return
    with open(source_path) as f:
        source = f.read()
    with open(target_path) as f:
        target = f.read()
    source_sections = get_sections(source)
    target_sections = get_sections(target)
    missing = {h: b for h, b in source_sections.items() if h not in target_sections}
    if missing:
        with open(target_path, 'a') as f:
            f.write('\n\n<!-- Merged from harness -->\n')
            for block in missing.values():
                f.write('\n' + block)
        print(f"✓ {label} (merged {len(missing)} section(s): {', '.join(missing.keys())})")
    else:
        print(f"✓ {label} (up to date)")

# Merge doc templates and CLAUDE.md into existing files
import shutil
for tmpl in ['CLAUDE', 'CURRENT', 'ARCHITECTURE', 'DECISIONS', 'SESSIONS']:
    tmpl_path = f'templates/{tmpl}.md'
    target_path = f'{tmpl}.md'
    if os.path.exists(target_path) and os.path.exists(tmpl_path):
        merge_md(tmpl_path, target_path, f'{tmpl}.md')
    elif os.path.exists(tmpl_path):
        shutil.copy(tmpl_path, target_path)
        print(f'✓ {tmpl}.md (created)')
EOF

# Create required directories
mkdir -p docs/evaluations docs/specs
echo "✓ docs/evaluations/ docs/specs/"

# Make hooks and scripts executable
chmod +x .claude/hooks/*.sh
chmod +x scripts/*.sh scripts/*.py 2>/dev/null
echo "✓ hooks executable"

# Install post-commit git hook
mkdir -p .git/hooks
cp scripts/post-commit.sh .git/hooks/post-commit
chmod +x .git/hooks/post-commit
echo "✓ post-commit hook installed"

# Update .gitignore
if ! grep -q "session-boundaries.log" .gitignore 2>/dev/null; then
  cat >> .gitignore << 'EOF'
.claude/session-boundaries.log
.claude/session-state.json
.claude/event-journal.log
.claude/transcript.log
EOF
  echo "✓ .gitignore"
fi


# Check for API key (subagent/ship mode)
if [ -f ".env" ]; then
  echo "✓ .env found"
elif [ -n "$ANTHROPIC_API_KEY" ]; then
  echo "✓ ANTHROPIC_API_KEY set in environment"
else
  echo "⚠  No ANTHROPIC_API_KEY found — /ship will run in sequential mode."
  echo "   To enable parallel subagents: copy .env.example to .env and add your key."
fi

# Check anthropic Python package
python3 -c "import anthropic" 2>/dev/null && echo "✓ anthropic SDK" || {
  echo "⚠  anthropic SDK not installed."
  read -p "   Install now? (needed for /ship API mode) [y/N]: " INSTALL_SDK
  if [[ "$INSTALL_SDK" =~ ^[Yy]$ ]]; then
    pip install anthropic && echo "✓ anthropic SDK installed"
  fi
}

echo ""
echo "============================================"
echo "✅ Automated setup complete."
echo "============================================"
echo ""
echo "⚠️  MANUAL STEPS REQUIRED:"
echo ""
echo "1. Reload your VSCode window to activate slash commands:"
echo "   Cmd+Shift+P → 'Developer: Reload Window'"
echo ""
echo "2. Set up git and push to a private remote:"
echo "   git init (if not done)"
echo "   git add -A && git commit -m 'init: project from claude-harness'"
echo "   gh repo create $PROJECT_NAME --private --source=. --push"
echo ""
echo "3. Run /init-project in Claude Code to populate your docs:"
echo "   This interviews you and fills CURRENT.md, ARCHITECTURE.md,"
echo "   DECISIONS.md, and creates starter domain specs."
echo ""
echo "============================================"
