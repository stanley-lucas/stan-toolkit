---
name: release
description: Create a new release — version bump, changelog, tag, push, GitHub release
allowed-tools: Bash, Read, Glob
---

# Release

## Step 1 — Pre-flight

Run in parallel:
```bash
cat package.json | grep '"version"'       # current version
git branch --show-current                 # must be main or develop
git tag --sort=-v:refname | head -5       # recent tags
git status --short                        # must be clean
git describe --tags --abbrev=0 2>/dev/null | xargs -I{} git log {}..HEAD --oneline | wc -l
```

Check if using Changesets:
```bash
ls .changeset/*.md 2>/dev/null | grep -v config.json | grep -v README.md | wc -l
```

## Step 2 — Validate

Before proceeding:
1. Clean working tree (no uncommitted changes)
2. At least 1 pending changeset (if using Changesets) — warn if zero
3. Remote is up to date

## Step 3 — Determine version

If using Changesets:
- Read `.changeset/pre.json` for prerelease mode (alpha/beta)
- Ask user: continue prerelease, exit prerelease, or normal bump?

If manual:
- Ask user: patch / minor / major?

## Step 4 — Version bump

With Changesets:
```bash
pnpm changeset:version   # or npx changeset version
```

Manual (npm):
```bash
npm version patch|minor|major --no-git-tag-version
```

## Step 5 — Review

Show the user:
```bash
cat package.json | grep '"version"'
head -50 CHANGELOG.md
git diff --stat
```

Ask for confirmation before proceeding.

## Step 6 — Commit

```bash
git add package.json CHANGELOG.md .changeset/
git commit -m "chore(release): version vX.Y.Z"
```

## Step 7 — Tag and push

Confirm with user before pushing:
```bash
git tag vX.Y.Z
git push origin [branch]
git push origin vX.Y.Z
```

## Step 8 — GitHub release

```bash
gh release create vX.Y.Z \
  --title "vX.Y.Z" \
  --prerelease \        # only for alpha/beta
  --generate-notes
```

## Rules

- NEVER skip user confirmation before push (Step 7)
- NEVER force push
- NEVER commit non-release files with the release commit
- Version in commit message MUST match package.json
