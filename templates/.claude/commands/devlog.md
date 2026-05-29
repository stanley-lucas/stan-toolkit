---
name: devlog
description: Draft a DEVLOG entry for the current session based on recent git activity
allowed-tools: Bash, Read, Edit
---

# /devlog

Drafts one or more DEVLOG entries based on what happened in the current session,
then appends them to `docs/DEVLOG.md` after your confirmation.

## Step 1 — Gather session activity

Run in parallel:

```bash
git log --oneline -10
```

```bash
git diff HEAD~3..HEAD --stat
```

If `docs/DEVLOG.md` exists, read the last 20 lines to find the most recent entry date
and avoid duplicating what's already logged.

## Step 2 — Draft entries

Based on the git activity, draft 1–3 DEVLOG entries covering what happened.

Rules:
- **What happened**: describe what was built or changed in plain language — what a colleague
  would need to know to understand the state of the project. Not a commit message summary.
- **Insight**: only include if something was genuinely non-obvious — a discovery, a surprise,
  something that changed your understanding. Omit the field entirely if nothing qualifies.
- Use the date of the most recent commit for each entry, not today's date.
- One entry per coherent unit of work, not one per commit.
- Keep entries under 4 lines total.

Format:
```
### YYYY-MM-DD — [Short title]
**What happened**: [plain language description]
**Insight**: [non-obvious learning — omit if nothing notable]
```

## Step 3 — Show and confirm

Print the drafted entries and ask: "Add these to DEVLOG.md? (yes / edit / skip)"

- **yes**: append the entries at the top of the entry section (after the `<!-- Add entries below -->` comment), newest first.
- **edit**: the user provides corrections inline, then re-confirm.
- **skip**: do nothing.

Do NOT write to the file without confirmation.

## Step 4 — Write

If confirmed, prepend the entries below the `<!-- Add entries below, newest first -->` comment in `docs/DEVLOG.md`.
Print the file path when done.
