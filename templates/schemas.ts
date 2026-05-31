// Zod schema stubs — copy to src/lib/schemas.ts and adapt to your domain.
// Use with parseBody() from validate.ts.
//
// Shared primitives worth keeping in most apps:
//   isoDate  — validates ISO date strings before new Date() conversion
//              prevents new Date("invalid") silently writing NaN to the DB
//   uuid     — validates UUID format (Zod v4 enforces RFC 4122 version bits;
//              test fixtures must use real v4 UUIDs, e.g. "a0000000-0000-4000-8000-000000000001")
//
// Behavior choices proven in production:
//   - Reject unknown enum values (don't silently default) — clearer errors
//   - Import arrays: max(N) to prevent unbounded DoS on bulk endpoints
//   - Partial PATCH schemas: use .refine() to require at least one field

import { z } from "zod";

// ── Shared primitives ────────────────────────────────────────────────────────

export const isoDate = z
  .string()
  .min(1)
  .refine((v) => !isNaN(Date.parse(v)), { message: "Must be a valid date string" });

export const uuid = z.string().uuid();

// ── Example schemas (replace with your domain) ────────────────────────────────

// export const createItemSchema = z.object({
//   name:        z.string().min(1),
//   description: z.string().optional(),
//   date:        isoDate,
//   ownerId:     uuid,
// });

// export const patchItemSchema = z
//   .object({ name: z.string().min(1).optional(), description: z.string().optional() })
//   .refine((d) => Object.keys(d).length > 0, { message: "At least one field required" });

// export const bulkCreateSchema = z.object({
//   items: z.array(itemRowSchema).min(1).max(500),
// });
