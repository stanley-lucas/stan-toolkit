---
name: context
description: Generate a one-paragraph summary of where the project is — recent activity, open issues, and next priority
allowed-tools: Bash, Read
---

# Context

Fast re-orientation after time away from the codebase. Run before `/start` when you're not sure where things stand.

## Step 1 — Gather state

Run in parallel:

```bash
git log --oneline -20
```

```bash
git branch -vv
```

```bash
gh issue list --state open --limit 15 --json number,title,labels,assignees
```

```bash
gh pr list --state open --limit 5 --json number,title,headRefName,isDraft
```

Read this project's `CLAUDE.md` — specifically the Project Overview and any roadmap references.

## Step 2 — Check for source of truth docs

If any of these exist, read the first 60 lines:
- `docs/prd/INDEX.md`
- `docs/ROADMAP.md`
- `ARCHITECTURE.md`

If `docs/DEVLOG.md` exists, read the last 5 entries (scan from the top entry comment downward).

## Step 3 — Generate summary

Produce a single structured block:

```
Context snapshot — [project name]
──────────────────────────────────
Recent: [2-3 sentences on what the last commits accomplished]
Open:   [N issues open — top priorities by label/recency]
PRs:    [N open PRs — any blocked or in draft?]
Next:   [most logical next action based on issues + recent work]
```

Keep the whole block under 10 lines. No bullet lists — prose and the structured header only.

## Rules

- If `gh` returns no issues, say so explicitly — don't omit the field
- If the branch is behind main, flag it in the summary
- Do not suggest code changes — this command is read-only
