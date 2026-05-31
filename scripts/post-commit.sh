#!/bin/bash
# Post-commit hook: reminds to update FEATURES.md when new pages or routes are added.
# Installed to .git/hooks/post-commit by scripts/setup.sh

new_routes=$(git diff HEAD~1 HEAD --name-only --diff-filter=A 2>/dev/null \
  | grep -E "(page|route)\.tsx?$" \
  | grep -v "__tests__\|\.test\.\|\.spec\.")

if [ -n "$new_routes" ]; then
  echo ""
  echo "⚠  New page/route files committed — update FEATURES.md:"
  echo "$new_routes" | sed 's/^/    /'
  echo "   Run /spec-update or add rows manually."
  echo ""
fi
