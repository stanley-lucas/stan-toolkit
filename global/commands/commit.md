---
name: commit
description: Stage all changes and create a commit with an AI-generated message
allowed-tools: Bash
---

# Commit

1. Run in parallel:
   - `git status` — see all changes (never use -uall)
   - `git diff` — unstaged changes
   - `git diff --cached` — staged changes
   - `git log --oneline -5` — recent commit style

2. Analyze all changes and draft a commit message:
   - Follow conventional commits: `type(scope): description`
   - Imperative mood. Focus on the WHY, not the what.
   - Include `Closes #XX` if resolving an issue.

3. Stage and commit using multiple -m flags:

```bash
git add [specific files — never -A blindly]
git commit -m "type(scope): description" -m "- What changed and why" -m "Closes #XX"
```

4. Run `git status` to verify.

## Rules

- Never stage `.env`, credential files, or secrets
- If pre-commit hooks fail, fix the issue and create a NEW commit (never --amend a published commit)
- Prefer staging specific files over `git add -A`
- If there are no changes, say so
