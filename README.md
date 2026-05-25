# lokey-dev-kit

Personal development kit for Claude Code. Provides standardized commands, templates, and conventions across all projects.

## Structure

```
global/                          # Goes into ~/.claude/
  CLAUDE.md                      # Universal standards (style, tests, commits)
  commands/
    commit.md                    # /commit
    push.md                      # /push
    pr.md                        # /pr
  settings.json                  # Hooks (prettier auto-format, notifications)

templates/                       # Copied into any project via install.sh
  CLAUDE.md                      # Project CLAUDE.md skeleton
  ARCHITECTURE.md                # Architecture doc skeleton
  .claude/
    commands/
      start.md                   # /start — session start protocol
      sync-docs.md               # /sync-docs — update source of truth
      release.md                 # /release — version bump + GitHub release
    settings.json                # Project hooks (prettier on write)
  docs/
    adr/000-template.md          # Architecture Decision Record template
    prd/INDEX.md                 # PRD index
    prd/TEMPLATE.md              # PRD template

install.sh                       # Bootstrap any project (never overwrites)
install-global.sh                # Install/update ~/.claude/
```

## Setup (once)

```bash
# 1. Install global config
./install-global.sh

# 2. Manually merge hooks into ~/.claude/settings.json if needed
```

## Bootstrap a new or existing project

```bash
./install.sh ~/path/to/project
```

Then fill in the TODO sections in the project's `CLAUDE.md` and `ARCHITECTURE.md`.

## Workflow in any project

| Command | What it does |
|---------|-------------|
| `/start new` | Classify work, propose branch |
| `/start fix issue-42` | Load issue context, verify branch |
| `/commit` | Stage + commit with conventional message |
| `/push` | Push to remote |
| `/pr` | Lint, type-check, push, create PR |
| `/sync-docs` | Update roadmap/PRD source of truth |
| `/release` | Version bump, tag, GitHub release |

## Evolving the kit

1. Edit files in `global/` or `templates/`
2. Re-run `install-global.sh` to push global changes to `~/.claude/`
3. For project templates, changes only apply to new installs (existing projects aren't updated)
4. Commit and push this repo to track your evolution

## Design principles

- **Global** (`~/.claude/CLAUDE.md`): universal standards, never repeated per project
- **Templates**: project skeleton, customized once per project
- **Project `.claude/`**: only project-specific overrides
- Scripts never overwrite existing files — safe to re-run
