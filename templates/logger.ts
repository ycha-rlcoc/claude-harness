// Structured JSON logger with PHI/PII redaction
// Copy to src/lib/logger.ts and adapt PHI_FIELDS to your data model.
//
// Design principles:
//   1. Structured JSON — every log line is parseable by log aggregators
//   2. PHI-safe — patient/user-identifying fields are stripped before logging
//   3. No stack traces — call frames can expose sensitive variable values
//   4. Level-routed — error→stderr, warn→stderr, info→stdout
//
// Usage:
//   import { log } from "@/lib/logger";
//   log("error", "Payment failed", { route: "/api/pay", error: err.message, userId });
//   // → {"level":"error","message":"Payment failed","route":"/api/pay","error":"...","ts":"..."}
//
// For Sentry / external error tracking: add a transport in the error branch.
// The log() call sites don't need to change — just update this file.

type Level = "info" | "warn" | "error";

// Fields stripped before any log line is emitted.
// Add any field that could identify a patient, user, or contain PII.
const PHI_FIELDS = new Set([
  // Adapt to your domain:
  "firstName", "lastName", "dateOfBirth", "dob",
  "email",          // log actor IDs or roles instead of email addresses
  "stack",          // stack traces may expose sensitive variable values
  // Add sensitive domain fields (e.g. "ssn", "address", "diagnosis"):
]);

// Returns a shallow copy of obj with PHI_FIELDS removed.
export function redact(obj: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(obj)) {
    if (!PHI_FIELDS.has(k)) out[k] = v;
  }
  return out;
}

// Emits one structured JSON line. context is redacted before logging.
// Pass: route, actorId, error.message, HTTP status, operation name.
// Never pass: Error objects, stack traces, or PHI field values.
export function log(
  level: Level,
  message: string,
  context: Record<string, unknown> = {}
): void {
  const line = JSON.stringify({
    level,
    message,
    ts: new Date().toISOString(),
    ...redact(context),
  });
  if (level === "error") console.error(line);
  else if (level === "warn")  console.warn(line);
  else                        console.log(line);
}
