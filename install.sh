#!/bin/bash
# install.sh — Bootstrap a project with stan-toolkit standards
#
# Philosophy:
#   - Never overwrites files that already exist without asking
#   - Each category is opt-in and skippable
#   - settings.json is merged (hooks appended), never replaced
#
# Usage: ./install.sh [project-path]

set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$KIT_DIR/lib/ui.sh"

PROJECT="${1:-.}"

if [ ! -d "$PROJECT" ]; then
  err "Directory not found: $PROJECT"
  exit 1
fi

PROJECT="$(cd "$PROJECT" && pwd)"

CREATED=0
SKIPPED=0
MERGED=0

# ── Banner ───────────────────────────────────────────────────────────────────
print_banner "STAN TOOLKIT" "Project bootstrap: $(basename "$PROJECT")"
info "Kit     : $KIT_DIR"
info "Project : $PROJECT"
echo ""

# ── Helper: copy file if missing, ask if exists ───────────────────────────────
install_file() {
  local src="$1"
  local dst="$2"
  local label="${3:-$dst}"

  mkdir -p "$(dirname "$dst")"

  if [ ! -f "$dst" ]; then
    cp "$src" "$dst"
    add "$label"
    CREATED=$((CREATED + 1))
  else
    ask_choice "  $(basename "$dst") already exists. What would you like to do?" \
      "Skip — keep existing" \
      "Diff — show differences" \
      "Replace — overwrite with toolkit version"

    case "$CHOICE" in
      1)
        skip "$label (kept existing)"
        SKIPPED=$((SKIPPED + 1))
        ;;
      2)
        show_diff_then_decide "$dst" "$src"
        if [ "$DIFF_CHOICE" = "replace" ]; then
          cp "$src" "$dst"
          ok "$label (replaced)"
          CREATED=$((CREATED + 1))
        else
          skip "$label (kept existing)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
      3)
        cp "$src" "$dst"
        ok "$label (replaced)"
        CREATED=$((CREATED + 1))
        ;;
    esac
  fi
}

# ── Step 1: Agent instruction files ──────────────────────────────────────────
print_section "Agent instruction files"
info "CLAUDE.md and AGENTS.md carry company standards into every AI session for this project."
echo ""

if ask_yn "Install CLAUDE.md (Claude Code + OpenCode)?"; then
  install_file "$KIT_DIR/templates/CLAUDE.md" "$PROJECT/CLAUDE.md" "CLAUDE.md"
else
  skip "CLAUDE.md (skipped)"
  SKIPPED=$((SKIPPED + 1))
fi

if ask_yn "Install AGENTS.md (Codex)?"; then
  install_file "$KIT_DIR/templates/AGENTS.md" "$PROJECT/AGENTS.md" "AGENTS.md"
else
  skip "AGENTS.md (skipped)"
  SKIPPED=$((SKIPPED + 1))
fi

# ── Step 2: Claude Code slash commands ───────────────────────────────────────
print_section "Slash commands (.claude/commands/)"
info "Company workflow commands: /start, /commit, /pr, /release, /context, /refactor..."
echo ""

if ask_yn "Install slash commands?"; then
  mkdir -p "$PROJECT/.claude/commands"
  for cmd in "$KIT_DIR"/templates/.claude/commands/*.md; do
    [ -f "$cmd" ] || continue
    name=$(basename "$cmd")
    dst="$PROJECT/.claude/commands/$name"

    if [ ! -f "$dst" ]; then
      cp "$cmd" "$dst"
      add ".claude/commands/$name"
      CREATED=$((CREATED + 1))
    else
      skip ".claude/commands/$name (already exists)"
      SKIPPED=$((SKIPPED + 1))
    fi
  done
else
  skip "Slash commands (skipped)"
  SKIPPED=$((SKIPPED + 1))
fi

# ── Step 3: settings.json (merge hooks, never replace) ───────────────────────
print_section "Claude Code hooks (.claude/settings.json)"

COMPANY_SETTINGS="$KIT_DIR/templates/.claude/settings.json"
PROJECT_SETTINGS="$PROJECT/.claude/settings.json"

if [ -f "$COMPANY_SETTINGS" ]; then
  if [ ! -f "$PROJECT_SETTINGS" ]; then
    if ask_yn "Install .claude/settings.json (project hooks)?"; then
      mkdir -p "$PROJECT/.claude"
      cp "$COMPANY_SETTINGS" "$PROJECT_SETTINGS"
      add ".claude/settings.json (created)"
      CREATED=$((CREATED + 1))
    else
      skip ".claude/settings.json (skipped)"
      SKIPPED=$((SKIPPED + 1))
    fi
  else
    info ".claude/settings.json already exists."
    ask_choice "What would you like to do?" \
      "Skip — keep existing" \
      "Diff — show differences" \
      "Replace — replace (will ask to confirm)"

    case "$CHOICE" in
      1)
        skip ".claude/settings.json (kept existing)"
        SKIPPED=$((SKIPPED + 1))
        ;;
      2)
        show_diff_then_decide "$PROJECT_SETTINGS" "$COMPANY_SETTINGS"
        if [ "$DIFF_CHOICE" = "replace" ]; then
          cp "$PROJECT_SETTINGS" "$PROJECT_SETTINGS.backup"
          cp "$COMPANY_SETTINGS" "$PROJECT_SETTINGS"
          ok ".claude/settings.json replaced (backup at settings.json.backup)"
          CREATED=$((CREATED + 1))
        else
          skip ".claude/settings.json (kept existing)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
      3)
        warn "This will replace .claude/settings.json."
        if ask_yn "  Are you sure?" "n"; then
          cp "$PROJECT_SETTINGS" "$PROJECT_SETTINGS.backup"
          cp "$COMPANY_SETTINGS" "$PROJECT_SETTINGS"
          ok ".claude/settings.json replaced (backup at settings.json.backup)"
          CREATED=$((CREATED + 1))
        else
          skip ".claude/settings.json (replacement cancelled)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
    esac
  fi
fi

# ── Step 4: Documentation structure ──────────────────────────────────────────
print_section "Documentation structure (docs/)"
info "PRD index, ADR template, DECISIONS log, DEVLOG."
echo ""

if ask_yn "Install doc structure?"; then
  DOCS=(
    "$KIT_DIR/templates/docs/prd/INDEX.md:$PROJECT/docs/prd/INDEX.md"
    "$KIT_DIR/templates/docs/prd/TEMPLATE.md:$PROJECT/docs/prd/TEMPLATE.md"
    "$KIT_DIR/templates/docs/adr/000-template.md:$PROJECT/docs/adr/000-template.md"
    "$KIT_DIR/templates/docs/DECISIONS.md:$PROJECT/docs/DECISIONS.md"
    "$KIT_DIR/templates/docs/DEVLOG.md:$PROJECT/docs/DEVLOG.md"
  )
  for entry in "${DOCS[@]}"; do
    src="${entry%%:*}"
    dst="${entry##*:}"
    [ -f "$src" ] || continue
    mkdir -p "$(dirname "$dst")"
    if [ ! -f "$dst" ]; then
      cp "$src" "$dst"
      add "${dst#"$PROJECT/"}"
      CREATED=$((CREATED + 1))
    else
      skip "${dst#"$PROJECT/"} (already exists)"
      SKIPPED=$((SKIPPED + 1))
    fi
  done
else
  skip "Documentation structure (skipped)"
  SKIPPED=$((SKIPPED + 1))
fi

# ── Step 5: ARCHITECTURE.md ──────────────────────────────────────────────────
print_section "Architecture doc"

if [ -f "$KIT_DIR/templates/ARCHITECTURE.md" ]; then
  if ask_yn "Install ARCHITECTURE.md skeleton?"; then
    install_file "$KIT_DIR/templates/ARCHITECTURE.md" "$PROJECT/ARCHITECTURE.md" "ARCHITECTURE.md"
  else
    skip "ARCHITECTURE.md (skipped)"
    SKIPPED=$((SKIPPED + 1))
  fi
fi

# ── Step 6: experiments/ sandbox ─────────────────────────────────────────────
print_section "Experiments sandbox"
info "A gitignored experiments/ directory for spikes and throwaway code."
echo ""

if ask_yn "Create experiments/ directory?"; then
  mkdir -p "$PROJECT/experiments"
  if [ ! -f "$PROJECT/.gitignore" ]; then
    echo "experiments/" > "$PROJECT/.gitignore"
    add ".gitignore (created with experiments/)"
    CREATED=$((CREATED + 1))
  elif ! grep -q "experiments/" "$PROJECT/.gitignore"; then
    echo "" >> "$PROJECT/.gitignore"
    echo "experiments/" >> "$PROJECT/.gitignore"
    ok "experiments/ added to .gitignore"
    MERGED=$((MERGED + 1))
  else
    skip "experiments/ already in .gitignore"
    SKIPPED=$((SKIPPED + 1))
  fi
else
  skip "experiments/ (skipped)"
  SKIPPED=$((SKIPPED + 1))
fi

# ── Done ─────────────────────────────────────────────────────────────────────
print_section "Done"
print_summary "$CREATED" "$SKIPPED" "$MERGED"

if [ $CREATED -gt 0 ]; then
  info "Next steps:"
  [ -f "$PROJECT/CLAUDE.md" ] && grep -q "TODO" "$PROJECT/CLAUDE.md" \
    && printf "    1. Fill in the TODO sections in CLAUDE.md\n"
  [ -f "$PROJECT/ARCHITECTURE.md" ] \
    && printf "    2. Fill in ARCHITECTURE.md\n"
  printf "    3. Customize .claude/commands/start.md with project vocabulary\n"
fi

echo ""
