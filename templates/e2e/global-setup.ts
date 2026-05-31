// E2E global-setup template
// Runs once before all tests. Handles DB migration + seeding.
//
// Key lesson: always TRUNCATE before seeding.
//   If your test DB was branched from another environment (Neon, PlanetScale,
//   or any branching DB), it inherits row data from the parent. Seed files that
//   use upsert(where: { uniqueField }) will fail with unique constraint errors
//   when a row with a different PK but the same unique value already exists.
//   Truncating first guarantees a clean slate regardless of branch history.
//
// Requires: DATABASE_URL_TEST env var pointing to an isolated test DB.

import { execSync } from "child_process";
import { PrismaClient } from "@prisma/client";   // swap for your ORM client

async function globalSetup() {
  if (!process.env.DATABASE_URL_TEST) {
    throw new Error(
      "DATABASE_URL_TEST is required for E2E tests. " +
      "Create an isolated test DB branch and add it to GitHub Secrets."
    );
  }

  // 1. Apply pending migrations to the test branch
  console.log("[E2E] Applying migrations...");
  execSync("npx prisma migrate deploy", {
    env: { ...process.env, DATABASE_URL: process.env.DATABASE_URL_TEST },
    stdio: "pipe",
  });

  // 2. Wipe all data — critical when using a branched DB that may have
  //    inherited rows from the parent environment.
  console.log("[E2E] Clearing test database...");
  const prisma = new PrismaClient({
    datasources: { db: { url: process.env.DATABASE_URL_TEST } },
  });
  try {
    // Replace table names with your schema. Order matters for FK constraints;
    // CASCADE handles most cases but list child tables before parents if not.
    await prisma.$executeRaw`
      TRUNCATE "YourTable", "AnotherTable"
      CASCADE
    `;
  } finally {
    await prisma.$disconnect();
  }

  // 3. Seed deterministic test data
  console.log("[E2E] Seeding test data...");
  execSync("npx tsx prisma/seed.ts", {
    env: { ...process.env, DATABASE_URL: process.env.DATABASE_URL_TEST },
    stdio: "pipe",
  });

  console.log("[E2E] Setup complete.");
}

export default globalSetup;
