// Integration test globalSetup — runs before workers fork.
// Sets DATABASE_URL to the test branch so ALL Prisma singletons
// (audit.ts, storage.ts, lib/prisma.ts) connect to the test DB,
// not the local dev DB.
//
// Add to vitest.integration.ts:
//   test: { globalSetup: ["./src/__tests__/integration/global-setup.ts"], ... }
//
// Why globalSetup and not setupFiles:
//   setupFiles run after module imports are hoisted. Prisma singletons initialize
//   on first import — before setupFiles can change DATABASE_URL. globalSetup
//   runs before workers fork, so env changes propagate to all test workers.

import { config } from "dotenv";

export default function setup() {
  config(); // load .env / .env.local
  if (process.env.DATABASE_URL_TEST) {
    process.env.DATABASE_URL = process.env.DATABASE_URL_TEST;
  }
}
