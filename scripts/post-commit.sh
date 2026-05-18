#!/bin/bash
# Post-commit: runs tests if testCommand is set in .claude/project.json
PROJECT_JSON="$(git rev-parse --show-toplevel)/.claude/project.json"
if [ ! -f "$PROJECT_JSON" ]; then exit 0; fi

TEST_CMD=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d.get('testCommand',''))" "$PROJECT_JSON" 2>/dev/null)
if [ -z "$TEST_CMD" ]; then exit 0; fi

echo "→ Running tests: $TEST_CMD"
eval "$TEST_CMD"
if [ $? -ne 0 ]; then
  echo "⚠️  Tests failed after commit. Fix before pushing."
fi
