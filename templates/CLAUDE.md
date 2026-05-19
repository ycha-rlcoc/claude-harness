# [Project Name]

[One-line description.]

## Read first
1. `CURRENT.md` — active phase, what's next
2. `ARCHITECTURE.md` — stack, structure, domain terms
3. `docs/specs/` — domain specs
4. `DECISIONS.md` — ADR log

## Diagnostic infra (keep permanently)
- `<ErrorBoundary>` at app root — on-screen stack + Copy button, stored at `window.__lastError`
- `<DevPanel>` behind `?debug=1` — nav stack, current screen, last 30 events
- Smoke tests for golden paths (Playwright)

## Project rules
- Deploy: foreground only, wait for confirmation before next command.
- API routes: permission check server-side, not just UI gating.

## After a feature ships
Offer (substantive features only): write/update tests, update `docs/specs/`.

## Universal rules
Read and follow: `rules/development.md`, `rules/models.md`, `rules/logging.md`
