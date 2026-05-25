---
name: sync-docs
description: Update source of truth docs to reflect what was just implemented
allowed-tools: Bash, Read, Edit
---

# Sync Docs

Update the project's source of truth after completing work.
Run after completing a significant feature, issue, or before `/pr`.

## Step 1 — Identify context

Run in parallel:
- `git branch --show-current`
- `git log --oneline -10`
- `git diff origin/main...HEAD --stat`

Determine level from branch name and commits:
- Branch contains `prd-NN` or commits reference a design doc → **Level 1**
- Branch contains `issue-NNN` or commits reference `#NNN` → **Level 2**
- Branch is `fix/`, `chore/`, `refactor/` → **Level 3**

## Step 2 — Update docs

Read this project's CLAUDE.md to find where source of truth docs live.
Common locations: `docs/prd/INDEX.md`, `docs/roadmap/ROADMAP.md`, `docs/PRODUCT.md`

**Level 1 (design doc / PRD work):**
- Mark completed user stories or tasks as done
- Update progress counts
- If fully complete, update overall status

**Level 2 (issue work):**
- Check if the issue closes a roadmap phase
- Mark phase complete if this was the last item

**Any level — new module:**
- Add new modules to any module map / product doc if missing

**Level 3 with no roadmap impact:** nothing to update — report that explicitly.

## Step 3 — Commit updates

If any doc was changed:
```bash
git add docs/
git commit -m "docs: sync source of truth — [what was completed]"
```

## Step 4 — Report

```
docs/prd/INDEX.md   — [what changed]
docs/ROADMAP.md     — [what changed or "no change"]
```

## Rules

- Only mark things as done that were actually implemented
- If unsure whether something was completed, ask before marking
- This command does NOT run pre-PR checks — that's `/pr`
