#!/usr/bin/env python3
"""
Run a single harness skill as a Claude API subagent.
Usage: python3 scripts/subagent.py <skill> [--model haiku|sonnet|opus] [--context "..."]
"""
import argparse, os, subprocess, sys
import anthropic

MODELS = {
    'haiku':  'claude-haiku-4-5-20251001',
    'sonnet': 'claude-sonnet-4-6',
    'opus':   'claude-opus-4-7',
}

# Default model per skill — optimize cost
SKILL_MODELS = {
    'review':          'sonnet',
    'security-review': 'haiku',
    'test-write':      'sonnet',
    'spec-update':     'haiku',
    'evaluate':        'sonnet',
    'validate-phase':  'haiku',
}

def git(cmd):
    return subprocess.getoutput(f'git {cmd}')

def read_file(path):
    return open(path).read() if os.path.exists(path) else ''

def get_context(skill_name):
    diff = git('diff HEAD~1 HEAD')
    contexts = {
        'review':          f"Diff to review:\n\n{diff}",
        'security-review': f"Diff to security-review:\n\n{diff}",
        'test-write':      f"Diff to write tests for:\n\n{diff}",
        'spec-update':     f"Recent commits:\n{git('log --oneline -10')}\n\nDiff:\n{diff}",
        'evaluate':        f"Recent commits:\n{git('log --oneline -20')}",
        'validate-phase':  f"Recent commits:\n{git('log --oneline -10')}",
    }
    return contexts.get(skill_name, diff)

def run(skill_name, model_key, extra_context=''):
    skill_path = f'.claude/skills/{skill_name}/SKILL.md'
    if not os.path.exists(skill_path):
        print(f"Error: skill not found at {skill_path}", file=sys.stderr)
        sys.exit(1)

    skill      = read_file(skill_path)
    arch       = read_file('ARCHITECTURE.md')
    claude_md  = read_file('CLAUDE.md')
    context    = get_context(skill_name)
    if extra_context:
        context += f"\n\nAdditional context:\n{extra_context}"

    model = MODELS[model_key]
    print(f"\n🤖  /{skill_name} subagent ({model_key})...\n", flush=True)

    client = anthropic.Anthropic()
    with client.messages.stream(
        model=model,
        max_tokens=4096,
        messages=[{
            "role": "user",
            "content": (
                f"You are running the /{skill_name} skill.\n\n"
                f"Project conventions (CLAUDE.md):\n{claude_md}\n\n"
                f"Architecture:\n{arch}\n\n"
                f"Context:\n{context}\n\n"
                f"Follow these instructions:\n\n{skill}"
            )
        }]
    ) as stream:
        for text in stream.text_stream:
            print(text, end='', flush=True)
    print()

if __name__ == '__main__':
    if not os.environ.get('ANTHROPIC_API_KEY'):
        print("Error: ANTHROPIC_API_KEY not set.", file=sys.stderr)
        sys.exit(1)

    p = argparse.ArgumentParser()
    p.add_argument('skill')
    p.add_argument('--model', choices=MODELS.keys(),
                   default=None, help='Override default model for this skill')
    p.add_argument('--context', default='')
    args = p.parse_args()

    model_key = args.model or SKILL_MODELS.get(args.skill, 'sonnet')
    run(args.skill, model_key, args.context)
