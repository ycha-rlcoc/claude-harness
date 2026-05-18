# Architecture

<!--
PURPOSE: Gives Claude (and new developers) a complete mental model of the system
in one read. The goal is to replace 2,000 tokens of source-file traversal with
300 tokens of structured context.

Keep this to 300 lines max. If it gets longer, it's too detailed — move specifics
into domain specs in docs/specs/.

Update this when you change the stack, add a major component, or establish a new pattern.
-->

## Stack

<!--
One line per technology. Include the version if it matters.
Focus on what's actually used, not aspirational.
-->

- **Runtime:** [e.g. Node 20, Python 3.12, Ruby 3.3]
- **Framework:** [e.g. Next.js 16 App Router, Rails 7, FastAPI]
- **Database:** [e.g. Postgres 16 via Neon, SQLite via Turso]
- **ORM/Query layer:** [e.g. Prisma 5, ActiveRecord, SQLAlchemy]
- **Auth:** [e.g. Clerk, Devise, custom JWT]
- **Storage:** [e.g. Supabase Storage, S3, Cloudflare R2]
- **Styling:** [e.g. Tailwind 4, CSS Modules, styled-components]
- **UI components:** [e.g. shadcn/ui + base-ui, Radix, MUI]
- **Testing:** [e.g. Vitest + Playwright, RSpec + Capybara, pytest]
- **Deploy:** [e.g. Vercel, Fly.io, Railway, AWS App Runner]

## File structure

<!--
Show only the non-obvious parts. Standard framework directories (node_modules,
.next, vendor) don't need explanation. Focus on custom structure and conventions.

Example for a Next.js App Router project:
-->

```
src/
  app/              # Next.js App Router pages and API routes
    admin/          # Admin role — only accessible with role=admin
    officer/        # Probation officer role
    api/            # REST API routes (one folder per resource)
  components/       # Shared React components
    ui/             # shadcn/ui primitives (don't modify directly)
  lib/              # Utilities: auth, db, storage, audit
docs/
  specs/            # Domain specs (one file per domain)
  evaluations/      # /evaluate session reports
.claude/            # Claude Code configuration
  skills/           # Custom slash commands
  hooks/            # Lifecycle scripts
```

## Key conventions

<!--
Patterns established in this project that Claude should follow without re-deriving.
These are the "invisible rules" that aren't obvious from reading one file.
Add entries here when you establish a pattern — otherwise future sessions will reinvent it.
-->

- [e.g. All DB queries use `dbUserId` (Postgres UUID), never `userId` (auth provider string)]
- [e.g. All API routes check permissions server-side — never rely on UI gating alone]
- [e.g. Tables use `hidden md:block` desktop + `md:hidden` card for mobile]
- [e.g. Page transitions use CSS keyframes only — not JS animation libraries]

## Data flow

<!--
Describe how data moves through the system for the primary use case.
One or two paragraphs or a short sequence. Not exhaustive — just the main path.
-->

[e.g. User authenticates via Clerk → role read from publicMetadata → role gates API routes
via auth() → Prisma queries use dbUserId → responses never include raw file paths (signed URLs only)]

## Domain terms

<!--
A glossary of project-specific nouns. Prevents me from asking "what does X mean?"
mid-task. Add any term that would be ambiguous to someone new.
-->

| Term | Meaning |
|------|---------|
| [Term] | [One sentence definition] |

## Sensitive data rules

<!--
Hard rules about data that must never appear in certain places.
These belong here so they're impossible to miss.
-->

- [e.g. No PHI in email bodies — notification emails contain only a portal link]
- [e.g. No file URLs exposed directly — always use signed URLs with expiry]
