# Decisions

<!--
PURPOSE: A running log of significant choices made during development — especially
ones where multiple options existed and you chose one for a specific reason.

Why this matters: Without this, future sessions re-debate settled questions.
"Why did we use X instead of Y?" gets answered here instead of re-litigated.

FORMAT: Newest entry at the top. Each entry: what was decided, why, and what was
rejected. Keep entries short — 2-4 sentences is enough.

WHEN TO ADD: Whenever you choose between real alternatives, defer something
intentionally, or make a tradeoff that isn't obvious from the code.
-->

---

## [YYYY-MM-DD] — [Short title of the decision]

**Decision:** [What was chosen]
**Reason:** [Why — constraints, tradeoffs, data that informed the choice]
**Rejected:** [What alternatives were considered and why they lost]

---

## [YYYY-MM-DD] — Example: Chose Neon over Supabase Postgres for production DB

**Decision:** Neon (via Vercel Marketplace) is the production database.
**Reason:** Supabase Postgres pooler authentication repeatedly failed (password/auth method mismatch, unresolved). Neon provisioned in 2 minutes with zero auth issues via Vercel Marketplace integration.
**Rejected:** Supabase Postgres — retained for file storage only (lab-results bucket).

---

<!-- Add new decisions above this line, newest first -->
