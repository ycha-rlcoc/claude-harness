// Playwright config template
// Key lessons baked in:
//   1. Use testMatch per project — never testIgnore only. testIgnore runs every
//      other spec under the wrong role context (e.g. admin visiting officer pages
//      with an empty caseload). Each project must own exactly its spec files.
//   2. Explicit port in webServer.command — next dev defaults vary; be explicit.
//   3. No wait-on in CI — webServer block handles startup. Remove any
//      `npm run dev & wait-on http://...` patterns from the CI workflow.
//   4. fullyParallel: false when tests share a DB — prevents race conditions.

import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: false,       // set true only if tests are fully DB-isolated
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? "github" : "list",
  use: {
    baseURL: "http://localhost:3000",
    trace: "on-first-retry",
  },
  projects: [
    // Fixture setup — runs first, creates auth state files for each role
    { name: "setup", testMatch: /e2e\/setup\.ts/ },

    // One project per role — each declares testMatch for the specs it owns.
    // Do NOT use testIgnore alone; it runs every other spec under the wrong role.
    {
      name: "admin",
      use: { ...devices["Desktop Chrome"], storageState: "e2e/fixtures/admin.json" },
      dependencies: ["setup"],
      testMatch: /admin\.spec\.ts/,     // <-- list only specs this role owns
    },
    {
      name: "permissions",
      use: { ...devices["Desktop Chrome"] },
      dependencies: ["setup"],
      testMatch: /permissions\.spec\.ts/,
    },
    // Add more role projects here following the same pattern
  ],
  globalSetup: "./e2e/global-setup.ts",
  globalTeardown: "./e2e/global-teardown.ts",
  webServer: {
    command: "next dev --port 3000",    // explicit port — don't rely on default
    url: "http://localhost:3000",
    reuseExistingServer: !process.env.CI,
    timeout: 60_000,
  },
});
