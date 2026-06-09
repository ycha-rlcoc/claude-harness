# Development Rules

## Bug-fix
1. Hypothesize first — 2–3 causes + distinguishing test before writing code.
2. Verify locally before deploying.
3. Commit each working state. Don't batch.
4. One bug per attempt. Ask for stack trace before reading source.

## Reading
- Grep before Read. Use offset/limit.
- Check ARCHITECTURE.md before re-deriving from source.
- When working from a diff or error output, read only the changed/affected files and immediate context — do not read the whole codebase.
- **Follow spec pointers.** A top-of-file `// Spec: docs/specs/<name>.md` comment means the business rules for that code live in the named spec. Read it before changing the logic — don't re-derive intent from the code alone.

## Specs ↔ code linkage
- Each domain spec's primary source file carries a top-of-file `// Spec: docs/specs/<name>.md` comment. This keeps business rules one hop away when reading code, and is the reciprocal of the spec's own "Key files" section.
- When you create a domain spec, add the pointer comment to its primary source file. When you move the logic, move the pointer.

## Structure & maintainability
These keep change blast-radius small — which is also what keeps an AI's per-change token cost low (fewer files to read, fewer to edit, less intent to re-derive).
- **Centralize cross-cutting values (the 3+ rule).** Any constant, mapping, or type referenced in 3+ places goes in one module that the call sites import. A scattered value means every change reads and edits N files and risks missing one; a centralized one is a single edit. Watch for it in routing tables, role/permission maps, status enums, and config.
- **Generalize the mechanism instead of special-casing.** When a fix adds a special case on top of shared infrastructure, that is a signal the underlying mechanism isn't deep enough. Prefer extending the shared mechanism (a helper, a config entry) over layering conditionals — special cases compound.
- **Name things so grep finds them.** Consistent, predictable names make a file's location guessable without reading the tree.

## Integration testing

- **Use `globalSetup` to redirect DATABASE_URL before workers fork.** When integration tests use a separate test DB branch, any Prisma singleton imported by the code under test will connect to the wrong DB unless DATABASE_URL is set before the worker process starts. `setupFiles` run after module imports are hoisted — too late for singleton initialization. Use `globalSetup` + dotenv to set `DATABASE_URL = DATABASE_URL_TEST` before workers fork. See `templates/e2e/integration-global-setup.ts`.
- **Scope `afterEach` to tables that need per-test isolation only.** An `afterEach` that truncates tables managed by another file's `beforeAll` causes cross-file interference when vitest runs files concurrently in singleFork mode. Truncate only the tables whose rows must not leak between individual tests (e.g. AuditLog, event queues). Let each test file manage its own domain data in file-level `beforeAll`/`afterAll`.
- **Ratchet coverage thresholds after a backfill.** After closing coverage gaps, update thresholds to match current actuals (not aspirational targets). Set them 1-2 points below actuals so CI catches regressions without blocking new features that temporarily lower coverage. Repeat after each backfill sprint.

## Input validation & observability

- **Validate every request body with a schema before touching it.** Never trust `req.json()` raw — use a Zod schema (or equivalent) and a `parseBody()` helper that returns a structured 400 on failure. See `templates/validate.ts` + `templates/schemas.ts`. Key gotchas: (a) use `isoDate` refine to prevent `new Date("invalid")` silently writing NaN; (b) use `max(N)` on bulk-import arrays to prevent DoS; (c) reject unknown enum values — don't silently default; (d) Zod v4 enforces RFC 4122 UUID variant bits, so test fixtures must be real v4 UUIDs.
- **Log errors structurally, never silently.** Every catch block must emit a structured log line (level, message, context). Never log PHI — strip patient-identifying fields before logging (see `templates/logger.ts`). Never log stack traces — they can contain variable values from sensitive call frames. Prefer logging `error.message` over the full Error object.

## Verification
- **Run locally what CI runs, before pushing.** Each CI stage should have a local script equivalent (unit, integration, e2e) that works against the test DB. A 3-minute CI round-trip to discover a failure you could have caught in seconds locally is wasted — and for an AI it also burns a full read of the CI logs. Discover failures at the cheapest layer.

## Skill recommendations (proactive)

Suggest the right skill before the user has to ask. One short line, not a lecture.

| Signal | Suggest |
|---|---|
| User describes a new feature | `/tdd` — define the contract first |
| Build fails / CI red / deploy hanging | `/build-fix` |
| Feature feels done, about to commit | `/ship` |
| "Is this ready for users?" / pre-launch | `/production-audit` |
| First session in a repo / returning after a break | `/onboard` |
| Planning work spanning multiple sessions or PRs | `/blueprint` |
| Session ending with substantial work done | `/evaluate` |
| CLAUDE.md / rules have grown over several sessions | `/context-budget` — trim always-on context |
| Something wrong with harness setup | `/workspace-audit` |
| After adding 3+ new skills | `/rules-distill` then `/skill-stocktake` |
| New project from harness template | `bash scripts/setup.sh` then `/init-project` |
| About to do destructive action (rm, force push, DROP) | Confirm intent; safety-guard hook will intercept |

## Output
- Present proposed changes, fixes, and actions one at a time with explicit approve/deny (yes / no / stop). Never batch multiple changes in a single approval prompt.

## Don't
- Speculative fixes without verification.
- Escalate scope without consent.
- Strip diagnostics same turn as shipping.
- Repeat same fix — fix #2 needs new information.
- Verbose responses. Short sentences. No preamble.

## Dependency & env security

- **Scan dependencies in CI.** Add `npm audit --audit-level=high` (or equivalent) to the CI pipeline. Unfixable upstream vulnerabilities should be documented with a suppression comment — don't ignore them silently. Enable Dependabot or Renovate for automated update PRs.
- **Validate env vars at startup.** Create an `env.ts` (or equivalent) that parses all required environment variables with a schema (Zod, etc.) at module load time. A missing var should throw with a clear message before the app starts — not fail silently on the first API call that needs it. See `templates/env.ts`. Test by adding baseline values to `test.env` in the test config, not `beforeEach` stubs (which can't fire before module-level imports).
- **Add security headers.** Every HTTP response should include at minimum: `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Strict-Transport-Security`, `Referrer-Policy`, and a `Content-Security-Policy`. See `templates/next.config.headers.ts` for a Next.js starter. Adjust CSP to match your auth and API providers before going to production.

## Auth & security

- **Every section/layout must enforce authorization independently from the API layer.** Route middleware typically only checks authentication (logged in) — not authorization (role). Any layout, middleware, or route group that gates access to a section must check the user's role and redirect/reject before rendering or returning data. API-level 403s are necessary but not sufficient — the UI layer can expose sensitive structure before the API check fires.
- **Write security contracts as tests before implementation** — use `/tdd`. Role checks, permission denials, and required audit entries are correctness requirements, not implementation details. Write the failing test first so they can't be omitted.
- **Sibling file audit after a security fix.** When a security pattern is added to one file (e.g. a role guard to one layout), immediately check all sibling files of the same type for the same gap. A fix in one place often reveals the same issue was missed elsewhere.

## E2E testing

- **Never use bare `getByText()` on data-heavy pages.** User-generated content (names, IDs, dynamic labels) will substring-match UI chrome. Use `getByRole` with `exact`, `href` attribute selectors, or `data-testid` for any element whose label might appear in data rows.
- **Scope test projects explicitly.** Each test project/suite must declare an explicit include pattern for the specs it owns. An exclude-only approach silently runs unintended specs under the wrong user context.
- **Truncate before seeding in E2E global-setup.** If the test DB was branched from another environment (Neon, PlanetScale, etc.), it inherits row data. Seed files using upsert by unique key will fail with constraint errors. Always truncate before seeding.
