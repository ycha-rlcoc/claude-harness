// Request body validation helper
// Copy to src/lib/validate.ts. Pair with Zod schemas in src/lib/schemas.ts.
//
// Usage in an API route:
//   const result = await parseBody(mySchema, req);
//   if (!result.ok) return result.response;   // structured 400, no try/catch needed
//   const { field } = result.data;            // fully typed, validated
//
// Error shape on 400:
//   { error: "Invalid request body", fields: [{ field: "name", message: "..." }] }
//   { error: "Invalid request body", detail: "Could not parse JSON" }
//
// Test tip: use vi.mock("@/lib/env") in tests for modules that import env.ts
// at module load time. vi.stubEnv() in beforeEach fires too late for
// module-level side effects — add baseline values to vitest.config.ts test.env.

import { NextResponse } from "next/server";
import { ZodSchema } from "zod";

type ParseOk<T> = { ok: true; data: T };
type ParseErr = { ok: false; response: NextResponse };
export type ParseResult<T> = ParseOk<T> | ParseErr;

export async function parseBody<T>(
  schema: ZodSchema<T>,
  req: Request
): Promise<ParseResult<T>> {
  let raw: unknown;
  try {
    raw = await req.json();
  } catch {
    return {
      ok: false,
      response: NextResponse.json(
        { error: "Invalid request body", detail: "Could not parse JSON" },
        { status: 400 }
      ),
    };
  }

  const parsed = schema.safeParse(raw);
  if (!parsed.success) {
    const fields = parsed.error.issues.map((i) => ({
      field: i.path.join("."),
      message: i.message,
    }));
    return {
      ok: false,
      response: NextResponse.json(
        { error: "Invalid request body", fields },
        { status: 400 }
      ),
    };
  }

  return { ok: true, data: parsed.data };
}
