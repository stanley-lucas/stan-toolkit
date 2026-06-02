---
name: pr
description: Create a pull request on GitHub
allowed-tools: Bash, Read
---

# Pull Request

## Step 1 — Check state

Run in parallel:
- `git status --short`
- `git branch --show-current`
- `git log --oneline -10`
- `git diff origin/main...HEAD --stat`

If on `main`, refuse and warn.
If a PR already exists for this branch, return the existing URL.
If there are uncommitted changes, ask if the user wants to commit first.

## Step 2 — Lint and format

Run the project's formatter/linter (check project CLAUDE.md for the command).
Common patterns:
- `pnpm fix` or `pnpm lint:fix && pnpm format`
- `ruff check --fix && ruff format`

If it modified files, commit them before creating the PR:
```bash
git add -A
git commit -m "chore: apply lint and formatting"
```

## Step 3 — Type / static check

Run the project's type checker (check project CLAUDE.md).
Common patterns: `pnpm type-check`, `mypy`, `pyright`

If it fails, stop. Do NOT create the PR until errors are fixed.

## Step 4 — Push

```bash
git push -u origin HEAD   # if no upstream
git push                  # if already tracking
```

## Step 5 — Create PR

Check if `.github/pull_request_template.md` exists and use it.
Otherwise use this structure:

```bash
gh pr create \
  --title "type(scope): description (#NNN)" \
  --body "$(cat <<'EOF'
## Summary
- ...

## Test plan
- [ ] ...

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Return the PR URL.

## Rules

- Type check failure → stop, fix first
- Lint side effects must be committed BEFORE the PR is created
- Never force push, never skip hooks
