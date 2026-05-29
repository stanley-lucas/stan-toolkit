# ai-dev-kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Personal development kit for Claude Code. Standardized commands, templates, and conventions that travel with me across every project.

## What it is

A thin layer on top of Claude Code that encodes my working style once, so I never repeat it per project:

- **Global standards** (`~/.claude/`) — code style, commit format, test rules, what I never do. Applied to every Claude session automatically.
- **Project templates** — a starter `CLAUDE.md`, `ARCHITECTURE.md`, doc structure, and slash commands, copied into any new project in seconds.
- **Slash commands** — a consistent workflow vocabulary across all projects (`/context`, `/start`, `/commit`, `/refactor`, `/pr`, `/release`).

## Philosophy

> Human decides **what** and **why**. AI decides **how**.

- Small releases: every commit is production-ready.
- Continuous refactoring: small, immediate surgery. Never let debt accumulate.
- Atomic commits: one concern per commit, never mix unrelated changes.

---

## Structure

```
global/                          # Installed into ~/.claude/
  CLAUDE.md                      # Universal standards (style, tests, commits, what I never do)
  commands/
    commit.md                    # /commit — lint, stage, conventional commit
    push.md                      # /push  — push with safety checks
    pr.md                        # /pr    — lint, type-check, push, open PR
  settings.json                  # Global hooks (prettier auto-format on write, notifications)

templates/                       # Copied into any project via install.sh
  CLAUDE.md                      # Project CLAUDE.md skeleton (fill in TODOs)
  ARCHITECTURE.md                # Architecture doc skeleton
  .claude/
    commands/
      start.md                   # /start   — classify work, set up branch
      context.md                 # /context — snapshot of where the project stands
      refactor.md                # /refactor — targeted cleanup after a feature
      sync-docs.md               # /sync-docs — update PRD/roadmap source of truth
      release.md                 # /release — version bump, tag, GitHub release
      devlog.md                  # /devlog  — draft DEVLOG entries from recent git activity
    settings.json                # Project hooks (prettier on write)
  docs/
    adr/000-template.md          # Architecture Decision Record template
    prd/INDEX.md                 # PRD index
    prd/TEMPLATE.md              # PRD template
    DECISIONS.md                 # Quick decision log (read by /context)
    DEVLOG.md                    # Chronological engineering journal (read by /context and /devlog)

install.sh                       # Bootstrap any project (never overwrites existing files)
install-global.sh                # Install/update ~/.claude/
```

---

## Setup

### 1. Install global config (once)

```bash
git clone git@github.com:stanley-lucas/ai-dev-kit.git ~/ai-dev-kit
cd ~/ai-dev-kit
./install-global.sh
```

This copies `global/CLAUDE.md`, `global/commands/`, and `global/settings.json` into `~/.claude/`. Re-run any time to update.

> If you already have a `~/.claude/settings.json`, merge the hooks manually — the script won't overwrite it.

### 2. Bootstrap a project

```bash
./install.sh ~/path/to/project
```

What it installs (only if not already present — safe to re-run):

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project standards skeleton |
| `ARCHITECTURE.md` | Architecture doc skeleton |
| `.claude/commands/*.md` | Slash commands |
| `.claude/settings.json` | Project hooks |
| `docs/adr/`, `docs/prd/` | Doc structure |
| `docs/DECISIONS.md` | Quick decision log |
| `docs/DEVLOG.md` | Chronological engineering journal |
| `experiments/` | Gitignored spike sandbox |

Then fill in the TODO sections in `CLAUDE.md` and `ARCHITECTURE.md`.

---

## Slash commands

| Command | When to use |
|---------|-------------|
| `/context` | Re-orient after time away — shows recent commits, open issues, PRs, and the logical next step |
| `/start new` | Starting new work — classifies the task, proposes a branch name |
| `/start fix issue-42` | Loading context for a specific issue before diving in |
| `/commit` | Lint changed files → stage → write a conventional commit message |
| `/push` | Push to remote with safety checks |
| `/refactor` | After a feature lands — scan for drift (size, duplication, naming, depth) and apply surgical fixes |
| `/pr` | Lint, type-check, push, open a GitHub PR |
| `/sync-docs` | Update roadmap/PRD to reflect what was just shipped |
| `/release` | Version bump, git tag, GitHub release |
| `/devlog` | End of session — draft DEVLOG entries from recent git activity, confirm before writing |

### How `/context` works

Reads `git log`, open issues, open PRs, and any `docs/prd/INDEX.md` or `ARCHITECTURE.md`, then outputs a single structured block:

```
Context snapshot — my-project
──────────────────────────────────
Recent: last 2-3 commits in plain English
Open:   N issues open — top priorities
PRs:    N open PRs — any blocked or draft
Next:   most logical next action
```

### How `/refactor` works

Scoped to the current branch's changed files only. Scans for:
- Files over 300 lines (split candidates)
- Patterns repeated 3+ times (extraction candidates)
- Generic names (`data`, `result`, `handler`)
- Nesting beyond 2 levels
- Dead code

Proposes a list of candidates, asks for confirmation, then commits each change atomically — never mixes refactoring with behavior changes.

---

## Global standards (highlights)

The full rules live in `global/CLAUDE.md`. Key excerpts:

**Code style**
- Functions: 4–20 lines. Files: under 500 lines.
- No `any` in TypeScript, no untyped functions in Python.
- Early returns over nested ifs. Max 2 levels of indentation.
- Names must be specific — avoid `data`, `handler`, `Manager`.

**Tests**
- Every new function gets a test. Bug fixes get a regression test.
- Mock external I/O with named fake classes, not inline stubs.
- Tests must be F.I.R.S.T.

**Commits**
```
type(scope): short description (#issue)

- What changed and why

Closes #XX
```
Types: `fix`, `feat`, `docs`, `refactor`, `style`, `test`, `chore`

**What I never do**
- Commit to main directly
- Skip type checks or linters before a PR
- Use `--no-verify` or `--force`
- Add abstractions beyond what the task requires
- Design for hypothetical future requirements

---

## Evolving the kit

1. Edit files in `global/` or `templates/`
2. Re-run `./install-global.sh` to push global changes to `~/.claude/`
3. Template changes only apply to new project installs — existing projects aren't updated automatically
4. Commit and push to track your evolution
