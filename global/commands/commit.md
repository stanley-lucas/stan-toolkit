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

2. Check for lint/type issues on changed files:
   - Look up the lint and type-check commands in the project's `CLAUDE.md`
   - If staged files include `.ts`, `.tsx`, `.js`, or `.py` files, run the linter on those files only
   - If linter reports errors (not warnings), fix them before proceeding
   - If linter auto-fixes files, re-stage them

3. Analyze all changes and draft a commit message:
   - Follow conventional commits: `type(scope): description`
   - Imperative mood. Focus on the WHY, not the what.
   - Include `Closes #XX` if resolving an issue.

3. Stage and commit using multiple -m flags:

```bash
git add [specific files — never -A blindly]
git commit -m "type(scope): description" -m "- What changed and why" -m "Closes #XX"
```

4. Run `git status` to verify.

5. After a successful commit, check if `docs/DEVLOG.md` exists in the project root.
   - If it exists: ask "Want to log this session to DEVLOG? (yes / skip)"
     - **yes**: run `/devlog`
     - **skip**: do nothing
   - If it does not exist: skip silently — not every project uses the kit.

## Rules

- Never stage `.env`, credential files, or secrets
- If pre-commit hooks fail, fix the issue and create a NEW commit (never --amend a published commit)
- Prefer staging specific files over `git add -A`
- If there are no changes, say so
