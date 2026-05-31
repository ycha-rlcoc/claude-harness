// Environment variable validation template
// Copy to src/lib/env.ts and adapt the schema to your project's required vars.
//
// Why: validates all required env vars at module load time. A missing var
// throws immediately with a clear message rather than failing silently on the
// first API call that needs it.
//
// Test setup: add baseline values to vitest.config.ts test.env so env.ts
// parses cleanly before any module imports. vi.unstubAllEnvs() only clears
// vi.stubEnv() calls — it does NOT remove test.env baseline values.
//
//   // vitest.config.ts
//   test: {
//     env: {
//       DATABASE_URL: "postgresql://test@localhost/test",
//       SOME_API_KEY: "test-key",
//       NEXT_PUBLIC_APP_URL: "http://localhost:3000",
//     }
//   }
//
// Modules that import env.ts should be tested with vi.mock("@/lib/env", ...)
// rather than trying to re-stub process.env after module load.

import { z } from "zod";

const envSchema = z.object({
  // ── Database ──────────────────────────────────────────────────────────────
  DATABASE_URL: z.string().min(1, "DATABASE_URL is required"),

  // ── Auth ──────────────────────────────────────────────────────────────────
  // Example: make optional if your app has a dev bypass mode
  // AUTH_SECRET: z.string().min(1, "AUTH_SECRET is required"),

  // ── External APIs ─────────────────────────────────────────────────────────
  // SOME_API_KEY: z.string().min(1, "SOME_API_KEY is required"),

  // ── Public vars (safe to expose to browser) ───────────────────────────────
  NEXT_PUBLIC_APP_URL: z.string().url("NEXT_PUBLIC_APP_URL must be a valid URL"),

  NODE_ENV: z.enum(["development", "production", "test"]).default("development"),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  const missing = parsed.error.issues
    .map((i) => `  ${i.path.join(".")}: ${i.message}`)
    .join("\n");
  throw new Error(`Missing or invalid environment variables:\n${missing}`);
}

export const env = parsed.data;
