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
echo "  1. Fill in CLAUDE.md with your project's description and rules"
echo "  2. Create ARCHITECTURE.md, CURRENT.md, DECISIONS.md"
echo "  3. Copy docs/specs/_template.md to start writing domain specs"
echo "  4. Run: git init && git add -A && git commit -m 'init: project from claude-harness'"
