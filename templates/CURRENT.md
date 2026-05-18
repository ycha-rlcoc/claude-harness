# Current Status

<!--
PURPOSE: This is the first file Claude reads to understand where the project stands.
It should answer: "What exists right now, what's running, and what's next?"
Keep it current — update it when things ship or priorities change.
Stale CURRENT.md is worse than no CURRENT.md.
-->

## Infrastructure

<!--
List every layer of the stack with its current status.
Status options: ✅ Live | 🚧 In progress | 📋 Planned | ❌ Blocked
Be specific — "Postgres" is vague, "Neon Postgres via Vercel Marketplace" is useful.
-->

| Layer | What | Status |
|-------|------|--------|
| Framework | [e.g. Next.js 16, Rails 7, FastAPI] | 📋 |
| Auth | [e.g. Clerk, Auth0, Devise, custom JWT] | 📋 |
| Database | [e.g. Neon Postgres, Supabase, SQLite] | 📋 |
| File storage | [e.g. S3, Supabase Storage, Cloudflare R2] | 📋 |
| Deploy | [e.g. Vercel, Fly.io, Railway — include URL] | 📋 |
| Repo | [e.g. github.com/org/repo] | 📋 |
| CI | [e.g. GitHub Actions, CircleCI — what it runs] | 📋 |

## Running locally

<!--
The exact commands someone (or Claude) needs to run to get the app working locally.
Include any env var requirements or setup steps.
-->

```bash
# [setup commands]
# [dev server command + URL]
```

## What's built ✅

<!--
A list of completed features/milestones. Be specific — Claude reads this to understand
what's already done so it doesn't suggest rebuilding things that exist.
Group by area if there are many items.
-->

- [ ] [Example: User auth with email/password]
- [ ] [Example: Admin dashboard with client list]

## Next priorities

<!--
Ordered list of what to build next. Be specific enough that Claude can pick up
mid-session without re-asking what the plan is.
Move items here from "What's built" when they ship.
-->

1. [Most important thing to build next]
2. [Second priority]

## Known issues / blockers

<!--
Anything broken, stuck, or waiting on an external dependency.
Remove items when resolved.
-->

- [e.g. Supabase pooler auth fails — unresolved, using Neon instead]

## Before production

<!--
Hard requirements before going live with real users/data.
These should not be skipped — they represent risk or legal requirements.
-->

1. [e.g. Sign AWS BAA before storing real PHI]
2. [e.g. Security review of all API routes]
