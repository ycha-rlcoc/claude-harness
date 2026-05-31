#!/bin/bash
# Verify FEATURES.md covers every page and API route that exists in the codebase.
# Exits 1 (fails CI) if any route is missing from FEATURES.md.
# Run: bash scripts/check-features.sh

FEATURES="FEATURES.md"
if [ ! -f "$FEATURES" ]; then
  echo "⚠  FEATURES.md not found — skipping check"
  exit 0
fi

missing=0

# Pages: every page.tsx under src/app, converted to route path
while IFS= read -r file; do
  route=$(echo "$file" | sed 's|src/app||;s|/page\.tsx$||;s|^$|/|')
  if ! grep -qF "$route" "$FEATURES"; then
    echo "❌ Missing from FEATURES.md: $route  ($file)"
    missing=$((missing + 1))
  fi
done < <(find src/app -name "page.tsx" | sort)

# API routes: every route.ts under src/app/api
while IFS= read -r file; do
  route=$(echo "$file" | sed 's|src/app||;s|/route\.ts$||')
  if ! grep -qF "$route" "$FEATURES"; then
    echo "❌ Missing from FEATURES.md: $route  ($file)"
    missing=$((missing + 1))
  fi
done < <(find src/app/api -name "route.ts" | sort)

if [ "$missing" -eq 0 ]; then
  echo "✓ FEATURES.md covers all pages and API routes"
else
  echo ""
  echo "Run /spec-update or manually add the missing rows to FEATURES.md."
  exit 1
fi
