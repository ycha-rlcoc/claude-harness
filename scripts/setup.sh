#!/bin/bash
# Run this after cloning claude-harness to configure it for a new project.
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

# Write project config
cat > .claude/project.json << EOF
{
  "projectName": "$PROJECT_NAME",
  "productionUrl": "$PRODUCTION_URL",
  "testCommand": "$TEST_COMMAND",
  "deployCommand": "$DEPLOY_COMMAND"
}
EOF

# Update CLAUDE.md header
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/" CLAUDE.md 2>/dev/null || \
sed -i "s/\[Project Name\]/$PROJECT_NAME/" CLAUDE.md

# Copy doc templates (only if they don't already exist)
for tmpl in CURRENT ARCHITECTURE DECISIONS SESSIONS; do
  if [ ! -f "${tmpl}.md" ] && [ -f "templates/${tmpl}.md" ]; then
    cp "templates/${tmpl}.md" "${tmpl}.md"
    echo "✓ Created ${tmpl}.md from template"
  fi
done

# Ensure hooks are executable
chmod +x .claude/hooks/*.sh

# Gitignore the local state files
if ! grep -q "session-boundaries.log" .gitignore 2>/dev/null; then
  echo ".claude/session-boundaries.log" >> .gitignore
  echo ".claude/session-state.json" >> .gitignore
fi

echo ""
echo "✓ Configured for: $PROJECT_NAME"
echo "✓ Production URL: $PRODUCTION_URL"
echo "✓ Test command:   $TEST_COMMAND"
echo "✓ Deploy command: $DEPLOY_COMMAND"
echo ""
echo "Next steps:"
echo "  1. Run /init-project in Claude Code — it will interview you and populate"
echo "     CURRENT.md, ARCHITECTURE.md, DECISIONS.md, and create domain specs"
echo "  2. Or fill in the templates manually — each section has inline guidance"
echo "  3. Run: git init && git add -A && git commit -m 'init: project from claude-harness'"
