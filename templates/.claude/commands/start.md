---
name: start
description: 'Start a development session. Usage: /start new | feat | fix | chore'
allowed-tools: Bash, Read
---

# Session Start Protocol

Called as `/start $ARGUMENTS`. Complete all steps before writing any code.

---

## Mode: `new` (or empty)

Ask: **"What do you want to build or fix?"** — wait for a free-form answer.

Based on the answer, classify and propose:

```
Level : [1 — needs design doc / 2 — tracked issue / 3 — fix or chore]
Reason: [one line]
Branch: git checkout -b type/description
```

- Level 1 → `feat/prd-NN-description` or `feat/design-description`
- Level 2 → `feat/issue-NNN-description` or `fix/issue-NNN-description`
- Level 3 → `fix/description` or `chore/description`

Ask: **"Confirm the level and branch? (or adjust)"**

After confirmation:
- Level 1: guide to write a design doc / PRD first. End session here.
- Level 2: guide to create a GitHub issue. End session here.
- Level 3: create the branch and continue to Step 2.

---

## Mode: `feat`, `fix`, `chore`, or specific ref

### Step 1 — Load context

Read this project's `CLAUDE.md` and identify:
- GitHub repository (for `gh` commands)
- Domain vocabulary (canonical names for entities)
- Source of truth docs (roadmap, PRDs, issues)

If `$ARGUMENTS` contains an issue number (e.g. `fix issue-42`), run:
```bash
gh issue view 42 -R [repo from CLAUDE.md]
```

### Step 2 — Verify branch

```bash
git branch --show-current
```

- On `main` or `master`: stop. Instruct to create a branch first.
- On correct branch: confirm and continue.

### Step 3 — Vocabulary check

Read the Domain Vocabulary section of CLAUDE.md.
State the canonical names for this session:
> "Vocabulary: [term] (not [wrong term]), [term] (not [wrong term])..."

### Step 4 — Session summary

```
Session started
───────────────
Level   : [1 / 2 / 3]
Context : [design doc, issue, or description]
Branch  : [branch name]
Module  : [affected area]
Next    : [first concrete action]
```

---

## What NOT to do

- Do not write code before completing all steps
- Do not assume the branch is correct without checking
- Do not skip the vocabulary check even if it seems obvious
