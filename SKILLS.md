# Skills Quick Reference

## By workflow moment

### Starting work
| When | Skill |
|---|---|
| New feature — define contract first | `/tdd` |
| Multi-session / multi-PR work | `/blueprint` |
| Unfamiliar or inherited codebase | `/onboard` |
| Fresh project from harness template | `bash scripts/setup.sh` → `/init-project` |

### During development
| When | Skill |
|---|---|
| Build / tsc / lint fails | `/build-fix` |
| Swallowed exceptions, unawaited async | `/silent-failures` |
| Security concerns in changed code | `/security-review` |
| Code review on diff or PR | `/review` |

### Shipping
| When | Skill |
|---|---|
| Feature complete — full quality gate | `/ship` (Phase 0: build → Phase 1: review+security → Phase 2: tests+specs) |
| Deploy only (after /ship) | `/deploy` |
| Pre-launch / before real users or PHI | `/production-audit` |

### After shipping
| When | Skill |
|---|---|
| Write tests for code just shipped | `/test-write` |
| Update specs from recent commits | `/spec-update` |
| Advance to next phase in CURRENT.md | `/validate-phase` |

### End of session
| When | Skill |
|---|---|
| Substantive session complete | `/evaluate` |
| Extract instincts while fresh | `/continuous-learning` |
| Codify recurring patterns to rules | `/learn` |

### Harness maintenance
| When | Skill |
|---|---|
| Something wrong with harness setup | `/workspace-audit` |
| Audit token overhead | `/context-budget` |
| Added 3+ new skills recently | `/skill-stocktake` then `/rules-distill` |
| Skill behavior has changed / may be broken | `/test-skill <name>` |

---

## By problem type

| Problem | Skill |
|---|---|
| Build is broken | `/build-fix` |
| Silent errors / compliance risk | `/silent-failures` |
| Security vulnerabilities | `/security-review` |
| Production readiness unknown | `/production-audit` |
| Harness misconfigured | `/workspace-audit` |
| Skills feel stale or redundant | `/skill-stocktake` |
| Rules don't match what skills actually enforce | `/rules-distill` |

---

## Full skill list

| Skill | One-line description |
|---|---|
| `/blueprint` | Multi-session implementation planner — each step is self-contained |
| `/build-fix` | Diagnose and fix build errors |
| `/context-budget` | Audit token overhead across skills and CLAUDE.md |
| `/continuous-learning` | Extract session instincts and promote to rules/skills |
| `/deploy` | Sequential test → deploy |
| `/evaluate` | Session retrospective |
| `/init-project` | One-time project setup — populates all docs and specs |
| `/learn` | Codify evaluation patterns into rules or skills |
| `/onboard` | Generate CLAUDE.md by reading the codebase |
| `/production-audit` | Pre-launch / pre-PHI readiness checklist |
| `/review` | Code review on diff or PR |
| `/rules-distill` | Extract cross-cutting principles from skills into rules/ |
| `/safety-guard` | Check or explain the destructive command blocker |
| `/security-review` | OWASP scan on changed code |
| `/ship` | Full quality gate (build → review → security → tests → specs) |
| `/silent-failures` | Hunt swallowed exceptions and unawaited async |
| `/skill-stocktake` | Batch quality audit of all skills |
| `/spec-update` | Sync docs/specs/ from recent commits |
| `/tdd` | Write failing tests before implementation |
| `/test-skill <name>` | Regression check one skill against its golden spec |
| `/test-write` | Write tests for code just committed |
| `/validate-phase` | Gate check before advancing to next phase |
| `/workspace-audit` | Harness setup health check |
