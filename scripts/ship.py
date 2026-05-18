#!/usr/bin/env python3
"""
Orchestrate the full ship sequence with parallel API subagents.

Phase 1 (parallel): /review + /security-review
         → pause for fixes
Phase 2 (parallel): /test-write + /spec-update

Usage: python3 scripts/ship.py
"""
import concurrent.futures, os, subprocess, sys, threading

PHASE_1 = ['review', 'security-review']
PHASE_2 = ['test-write', 'spec-update']

lock = threading.Lock()

def run_skill(skill_name):
    result = subprocess.run(
        [sys.executable, 'scripts/subagent.py', skill_name],
        capture_output=True, text=True
    )
    return skill_name, result.stdout + result.stderr, result.returncode

def run_phase(skills, label):
    print(f"\n{'='*60}")
    print(f"  {label}")
    print(f"{'='*60}\n")

    with concurrent.futures.ThreadPoolExecutor(max_workers=len(skills)) as ex:
        futures = {ex.submit(run_skill, s): s for s in skills}
        for future in concurrent.futures.as_completed(futures):
            skill, output, code = future.result()
            with lock:
                print(f"\n── /{skill} ──────────────────────────────────")
                print(output.strip())

def main():
    if not os.environ.get('ANTHROPIC_API_KEY'):
        print("Error: ANTHROPIC_API_KEY not set.\nRun /ship inside Claude Code for sequential mode.")
        sys.exit(1)

    print("\n🚀  /ship — starting\n")

    run_phase(PHASE_1, "Phase 1: Review (parallel)")

    print("\n" + "="*60)
    print("  Phase 1 complete.")
    print("  Apply any fixes, then press Enter to continue.")
    print("="*60)
    input()

    run_phase(PHASE_2, "Phase 2: Tests + Specs (parallel)")

    print("\n" + "="*60)
    print("  ✅  /ship complete — ready to /deploy")
    print("="*60 + "\n")

if __name__ == '__main__':
    main()
