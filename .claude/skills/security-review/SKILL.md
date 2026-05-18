# /security-review

Security-focused review of changed code. Covers OWASP Top 10 + common API/auth issues.

## Steps

1. **Get the diff**
```bash
git diff HEAD~1 HEAD
```
Or a specified range/PR.

2. **Scan each changed file** for the following. Read only changed sections + immediate context — not full files.

## Checks

**Injection (A03)**
- SQL queries built with string concatenation or interpolation
- Shell commands constructed from user input
- Template injection, eval() on user data

**Auth & access control (A01, A07)**
- Missing auth middleware on new routes
- Role/permission checks on server side (not just UI)
- JWT verification — algorithm, expiry, signature check
- Password handling — hashing, no plaintext logging

**Sensitive data (A02)**
- Secrets, API keys, tokens hardcoded or logged
- PII in logs, error messages, or URLs
- Unencrypted sensitive fields in DB schema

**Security misconfiguration (A05)**
- CORS too permissive (`*`)
- Debug endpoints or verbose errors in production paths
- Missing rate limiting on auth or public endpoints

**Input validation (A03, A04)**
- User input used without validation or sanitization
- File upload without type/size checks
- Missing schema validation on API request bodies

**Dependency issues (A06)**
- New `npm install` / lockfile changes — note any unfamiliar packages

3. **Report by severity:**
```
/security-review — <commit>

🔴 Critical
- [file:line] [issue] — [attack vector]

🟡 Medium
- [file:line] [issue]

🟢 Low / hardening
- [file:line] [suggestion]

✅ Clean areas
- [what was checked and looks fine]
```

4. For each 🔴 issue: "Fix this now?" Apply on yes.

## What this skill does NOT do
- Does not run automated scanners — manual review only
- Does not review files outside the diff
- Does not flag style issues — security only
