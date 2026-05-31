#!/bin/bash
# Pre-push hook: runs tests + FEATURES.md check before any push goes remote.
# Installed to .git/hooks/pre-push by scripts/setup.sh.
# Fires for all git push invocations (git push, git push origin main, etc.).

set -e

echo "⏳ Running pre-push checks..."

echo "  Running unit tests..."
npm run test:coverage --silent

echo "  Checking FEATURES.md coverage..."
bash scripts/check-features.sh

echo "✅ Pre-push checks passed."
