---
name: push
description: Push current branch to remote origin
allowed-tools: Bash
---

# Push

1. Run `git status` — check branch, uncommitted changes, ahead/behind remote
2. Run `git branch -vv` — check if branch tracks a remote

3. If no upstream:
```bash
git push -u origin HEAD
```

4. If already tracking:
```bash
git push
```

5. Confirm push succeeded and report the result.

## Rules

- Never use `--force` unless explicitly requested
- If push fails due to conflicts, inform the user and suggest pulling first
- If there are uncommitted changes, ask if user wants to commit first
