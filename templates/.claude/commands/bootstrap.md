---
name: bootstrap
description: Seed DEVLOG.md and DECISIONS.md from the project's git history
allowed-tools: Bash, Read, Write, Edit
---

# /bootstrap

Seeds `docs/DEVLOG.md` and `docs/DECISIONS.md` from the existing git history of a project
that was not bootstrapped with the dev-kit from the start.

Run once, after installing the kit into an existing project.

## Step 1 — Check prerequisites

- Confirm `docs/DEVLOG.md` exists (created by `install.sh`). If not, tell the user to run `install.sh` first.
- Read the current contents of `docs/DEVLOG.md` and `docs/DECISIONS.md` to avoid duplicating existing entries.

## Step 2 — Gather history

Run in parallel:

```bash
git log --oneline --no-merges -50
```

```bash
git log --format="%ad %s" --date=short --no-merges -50
```

```bash
git log --no-merges -20 --format="%ad|%s|%b" --date=short
```

Also read if they exist:
- `ARCHITECTURE.md`
- `CLAUDE.md`
- `README.md` (first 60 lines)

## Step 3 — Draft DEVLOG entries

From the git history, identify 3–8 meaningful milestones — coherent units of work,
not individual commits. Group related commits into a single entry.

Rules:
- Use the date of the most recent commit in each group
- **What happened**: describe what was built in plain language
- **Insight**: only if something non-obvious is visible from the commit messages or code — omit otherwise
- Newest entry first
- Skip pure chore/style/dependency commits unless they represent a meaningful decision

## Step 4 — Draft DECISIONS entries

From the history and any existing docs, identify 2–5 architectural or stack decisions
that are visible but not yet in `DECISIONS.md`.

Rules:
- Only decisions that are non-obvious and load-bearing (stack choices, rejected approaches, major trade-offs)
- Use the date of the relevant commit
- Follow the existing format: **Decision** / **Why** / **Not** (optional)

## Step 5 — Show and confirm

Print both drafts and ask: "Write these entries? (yes / edit / skip)"

- **yes**: prepend entries into each file below their respective `<!-- Add entries -->` comments
- **edit**: user provides corrections, then re-confirm
- **skip**: do nothing

Do NOT write without confirmation.

## Step 6 — Write

If confirmed, write to both files. Print the file paths when done.
