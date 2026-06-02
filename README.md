# Stan Toolkit

> Personal development kit for Claude Code, Codex, and OpenCode.
> Standardized commands, standards, and templates that travel across every project.

---

## Philosophy

The developer is the pilot. The AI is the co-pilot.

The developer sets the direction — what to build, why, when to stop. The AI executes — code, tests, mechanical refactoring. This division keeps you in control of the product while the AI amplifies delivery speed.

Three principles that guide everything:

- **Small releases** — every commit ships production-ready. Nothing broken, nothing half-done.
- **Continuous refactoring** — surgical, immediate cleanup. Technical debt never accumulates.
- **Atomic commits** — one concern per commit. Never mix unrelated changes.

---

## Two-layer model

The AI reads two layers of instruction simultaneously: your personal preferences (global, on your machine) and the project standards (in the repository). They are additive, not competing.

```
Global layer (this toolkit)               Project layer
──────────────────────────────────        ──────────────────────────────────────
~/.claude/CLAUDE.md  ← personal style     [project]/CLAUDE.md  ← project standards
~/.claude/commands/  ← personal commands  [project]/.claude/commands/  ← project commands
~/.claude/settings.json ← hooks           [project]/.claude/settings.json ← project hooks
```

Company toolkits (e.g. sarcorps-toolkit) add their standards at the project layer — your global config stays untouched.

---

## Structure

```text
standards/               # Tool-agnostic source of truth
  CODING.md              # Style, tests, commits, what I never do

agents/                  # Instruction files per AI tool
  claude/
    CLAUDE.md            # Personal standards for Claude Code
    commands/            # Slash commands installed into ~/.claude/commands/
    settings.json        # Hooks (prettier on write, desktop notifications)
  codex/
    AGENTS.md            # Personal standards for Codex
  opencode/
    CLAUDE.md            # Personal standards for OpenCode

templates/               # Copied into any project via install.sh
  CLAUDE.md              # Project CLAUDE.md skeleton
  AGENTS.md              # Project AGENTS.md skeleton
  ARCHITECTURE.md        # Architecture doc skeleton
  .claude/
    commands/            # Project-level slash commands (8 commands)
    settings.json        # Project hooks (prettier on write)
  docs/
    prd/INDEX.md         # PRD index
    prd/TEMPLATE.md      # PRD template
    adr/000-template.md  # ADR template
    DECISIONS.md         # Quick decision log
    DEVLOG.md            # Engineering journal

lib/
  ui.sh                  # Shared installer UI (colors, prompts, banners)

install.sh               # Bootstrap a project (interactive, per-category)
install-global.sh        # Set up your machine (installs commands globally)
```

---

## Setup

### Step 1 — Clone the toolkit (once per machine)

```bash
git clone git@github.com:stanley-lucas/stan-toolkit.git ~/stan-toolkit
```

### Step 2 — Set up your machine (once per machine)

```bash
cd ~/stan-toolkit
./install-global.sh
```

The installer will ask which AI tools you use and install accordingly:

- **Claude Code**: slash commands are always installed/updated globally. CLAUDE.md and settings.json are opt-in.
- **Codex**: installs AGENTS.md into `~/.codex/`
- **OpenCode**: installs CLAUDE.md into `~/.opencode/`

For each file that already exists, you choose:

- **Skip** — nothing is changed
- **Reference** — saves a copy with `.stan` suffix alongside your existing file
- **Diff** — shows differences for manual merging
- **Replace** — replaces your file (double confirmation required)

### Step 3 — Bootstrap a project (once per repo)

```bash
cd ~/path/to/project
~/stan-toolkit/install.sh .
```

The installer walks through each category and asks before installing anything.

---

## Updating

```bash
cd ~/stan-toolkit
git pull
./install-global.sh   # re-run to update slash commands globally
```

Project templates only apply at bootstrap — existing projects are not updated automatically.
Re-run `./install.sh` on a project to update individual files.

---

## Slash commands

### Global (installed into `~/.claude/commands/`)

| Command | When to use |
|---|---|
| `/commit` | Lint → stage → conventional commit |
| `/push` | Push to remote with safety checks |
| `/pr` | Lint, type-check, push, open GitHub PR |

### Project-level (installed into `[project]/.claude/commands/`)

| Command | When to use |
|---|---|
| `/context` | Re-orient after time away — recent commits, open issues, next step |
| `/start new` | Start new work — classify, propose branch |
| `/start feat\|fix issue-NNN` | Load issue context before diving in |
| `/refactor` | After a feature — scan for drift and apply surgical fixes |
| `/sync-docs` | Update PRD/roadmap to reflect what was shipped |
| `/release` | Version bump, tag, GitHub release |
| `/devlog` | Draft DEVLOG entries from recent git activity |
| `/bootstrap` | One-time seed of DEVLOG and DECISIONS from git history |

---

## Evolving the toolkit

1. Edit `standards/CODING.md` for rule changes
2. Update `agents/claude/CLAUDE.md`, `agents/codex/AGENTS.md`, `agents/opencode/CLAUDE.md`
3. Update `templates/` if project scaffolding needs to change
4. Commit, push — re-run `./install-global.sh` to apply global changes
