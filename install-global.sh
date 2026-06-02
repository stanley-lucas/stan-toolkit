#!/bin/bash
# install-global.sh — Install stan-toolkit into ~/.claude/ (and other AI tools)
#
# Philosophy:
#   - Slash commands are always installed/updated globally (this IS the personal toolkit)
#   - CLAUDE.md is opt-in with 4 strategies if one already exists
#   - settings.json is opt-in and never silently replaced
#
# Usage: ./install-global.sh

set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$KIT_DIR/lib/ui.sh"

CLAUDE_DIR="$HOME/.claude"
CREATED=0
SKIPPED=0
MERGED=0

# ── Banner ───────────────────────────────────────────────────────────────────
print_banner "STAN TOOLKIT" "Global developer setup"
info "Kit location : $KIT_DIR"
info "Target       : $HOME/.claude  (Claude Code)"
echo ""

# ── Step 1: Which tools? ─────────────────────────────────────────────────────
print_section "Which AI coding tools do you use?"

ask_multiselect "Select all that apply:" \
  "Claude Code" \
  "Codex (OpenAI)" \
  "OpenCode"

USE_CLAUDE=false; USE_CODEX=false; USE_OPENCODE=false
for idx in $SELECTED; do
  case "$idx" in
    1) USE_CLAUDE=true ;;
    2) USE_CODEX=true ;;
    3) USE_OPENCODE=true ;;
  esac
done

[ "$USE_CLAUDE" = true ]   && ok   "Claude Code selected"   || skip "Claude Code skipped"
[ "$USE_CODEX" = true ]    && ok   "Codex selected"         || skip "Codex skipped"
[ "$USE_OPENCODE" = true ] && ok   "OpenCode selected"      || skip "OpenCode skipped"

# ── Step 2: Claude Code — slash commands (always installed/updated) ───────────
if [ "$USE_CLAUDE" = true ]; then
  print_section "Claude Code — Slash commands"
  info "Commands install into ~/.claude/commands/ and are always kept up to date."
  echo ""

  mkdir -p "$CLAUDE_DIR/commands"

  for cmd in "$KIT_DIR"/agents/claude/commands/*.md; do
    [ -f "$cmd" ] || continue
    name=$(basename "$cmd")
    dst="$CLAUDE_DIR/commands/$name"
    cp "$cmd" "$dst"
    add "~/.claude/commands/$name"
    CREATED=$((CREATED + 1))
  done
fi

# ── Step 3: Claude Code — CLAUDE.md (opt-in, 4 strategies) ──────────────────
if [ "$USE_CLAUDE" = true ] && [ -f "$KIT_DIR/agents/claude/CLAUDE.md" ]; then
  print_section "Claude Code — Global CLAUDE.md"

  PERSONAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
  KIT_CLAUDE="$KIT_DIR/agents/claude/CLAUDE.md"

  if [ ! -f "$PERSONAL_CLAUDE" ]; then
    info "No personal ~/.claude/CLAUDE.md found."
    if ask_yn "Install stan-toolkit CLAUDE.md as your global config?"; then
      cp "$KIT_CLAUDE" "$PERSONAL_CLAUDE"
      add "~/.claude/CLAUDE.md (created)"
      CREATED=$((CREATED + 1))
    else
      skip "~/.claude/CLAUDE.md (skipped)"
      SKIPPED=$((SKIPPED + 1))
    fi
  else
    info "You already have a personal ~/.claude/CLAUDE.md."
    echo ""
    ask_choice "What would you like to do with the stan-toolkit version?" \
      "Skip — keep mine as-is" \
      "Reference — save as ~/.claude/CLAUDE.stan.md to read later" \
      "Diff — show side-by-side diff in terminal" \
      "Replace — replace mine (will ask again to confirm)"

    case "$CHOICE" in
      1)
        skip "~/.claude/CLAUDE.md (kept existing)"
        SKIPPED=$((SKIPPED + 1))
        ;;
      2)
        cp "$KIT_CLAUDE" "$CLAUDE_DIR/CLAUDE.stan.md"
        add "~/.claude/CLAUDE.stan.md (reference copy)"
        info "Open it anytime: open ~/.claude/CLAUDE.stan.md"
        CREATED=$((CREATED + 1))
        ;;
      3)
        show_diff_then_decide "$PERSONAL_CLAUDE" "$KIT_CLAUDE"
        if [ "$DIFF_CHOICE" = "replace" ]; then
          cp "$PERSONAL_CLAUDE" "$PERSONAL_CLAUDE.backup"
          cp "$KIT_CLAUDE" "$PERSONAL_CLAUDE"
          ok "~/.claude/CLAUDE.md replaced (backup at CLAUDE.md.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.claude/CLAUDE.md (kept existing)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
      4)
        echo ""
        warn "This will REPLACE your personal ~/.claude/CLAUDE.md."
        if ask_yn "  Are you sure? This cannot be undone." "n"; then
          cp "$PERSONAL_CLAUDE" "$PERSONAL_CLAUDE.backup"
          cp "$KIT_CLAUDE" "$PERSONAL_CLAUDE"
          ok "~/.claude/CLAUDE.md replaced (backup at CLAUDE.md.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.claude/CLAUDE.md (replacement cancelled)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
    esac
  fi
fi

# ── Step 4: Claude Code — settings.json (opt-in) ────────────────────────────
if [ "$USE_CLAUDE" = true ] && [ -f "$KIT_DIR/agents/claude/settings.json" ]; then
  print_section "Claude Code — settings.json (hooks)"

  PERSONAL_SETTINGS="$CLAUDE_DIR/settings.json"
  KIT_SETTINGS="$KIT_DIR/agents/claude/settings.json"

  if [ ! -f "$PERSONAL_SETTINGS" ]; then
    info "No personal ~/.claude/settings.json found."
    if ask_yn "Install stan-toolkit settings.json?"; then
      cp "$KIT_SETTINGS" "$PERSONAL_SETTINGS"
      add "~/.claude/settings.json (created)"
      CREATED=$((CREATED + 1))
    else
      skip "~/.claude/settings.json (skipped)"
      SKIPPED=$((SKIPPED + 1))
    fi
  else
    info "You already have a personal ~/.claude/settings.json."
    ask_choice "What would you like to do?" \
      "Skip — keep mine as-is" \
      "Reference — save as ~/.claude/settings.stan.json to read later" \
      "Diff — show differences in terminal" \
      "Replace — replace mine (will ask again to confirm)"

    case "$CHOICE" in
      1)
        skip "~/.claude/settings.json (kept existing)"
        SKIPPED=$((SKIPPED + 1))
        ;;
      2)
        cp "$KIT_SETTINGS" "$CLAUDE_DIR/settings.stan.json"
        add "~/.claude/settings.stan.json (reference copy)"
        CREATED=$((CREATED + 1))
        ;;
      3)
        show_diff_then_decide "$PERSONAL_SETTINGS" "$KIT_SETTINGS"
        if [ "$DIFF_CHOICE" = "replace" ]; then
          cp "$PERSONAL_SETTINGS" "$PERSONAL_SETTINGS.backup"
          cp "$KIT_SETTINGS" "$PERSONAL_SETTINGS"
          ok "~/.claude/settings.json replaced (backup at settings.json.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.claude/settings.json (kept existing)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
      4)
        echo ""
        warn "This will REPLACE your personal ~/.claude/settings.json."
        if ask_yn "  Are you sure? This cannot be undone." "n"; then
          cp "$PERSONAL_SETTINGS" "$PERSONAL_SETTINGS.backup"
          cp "$KIT_SETTINGS" "$PERSONAL_SETTINGS"
          ok "~/.claude/settings.json replaced (backup at settings.json.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.claude/settings.json (replacement cancelled)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
    esac
  fi
fi

# ── Step 5: Codex ────────────────────────────────────────────────────────────
if [ "$USE_CODEX" = true ] && [ -f "$KIT_DIR/agents/codex/AGENTS.md" ]; then
  print_section "Codex — Global AGENTS.md"

  CODEX_DIR="$HOME/.codex"
  KIT_AGENTS="$KIT_DIR/agents/codex/AGENTS.md"
  PERSONAL_AGENTS="$CODEX_DIR/AGENTS.md"

  mkdir -p "$CODEX_DIR"

  if [ ! -f "$PERSONAL_AGENTS" ]; then
    if ask_yn "Install AGENTS.md into ~/.codex/?"; then
      cp "$KIT_AGENTS" "$PERSONAL_AGENTS"
      add "~/.codex/AGENTS.md (created)"
      CREATED=$((CREATED + 1))
    else
      skip "~/.codex/AGENTS.md (skipped)"
      SKIPPED=$((SKIPPED + 1))
    fi
  else
    ask_choice "~/.codex/AGENTS.md already exists. What would you like to do?" \
      "Skip — keep mine as-is" \
      "Reference — save as ~/.codex/AGENTS.stan.md" \
      "Diff — show differences" \
      "Replace — replace mine (will ask again to confirm)"

    case "$CHOICE" in
      1) skip "~/.codex/AGENTS.md (kept existing)"; SKIPPED=$((SKIPPED + 1)) ;;
      2)
        cp "$KIT_AGENTS" "$CODEX_DIR/AGENTS.stan.md"
        add "~/.codex/AGENTS.stan.md (reference copy)"
        CREATED=$((CREATED + 1))
        ;;
      3)
        show_diff_then_decide "$PERSONAL_AGENTS" "$KIT_AGENTS"
        if [ "$DIFF_CHOICE" = "replace" ]; then
          cp "$PERSONAL_AGENTS" "$PERSONAL_AGENTS.backup"
          cp "$KIT_AGENTS" "$PERSONAL_AGENTS"
          ok "~/.codex/AGENTS.md replaced (backup at AGENTS.md.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.codex/AGENTS.md (kept existing)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
      4)
        warn "This will REPLACE your personal ~/.codex/AGENTS.md."
        if ask_yn "  Are you sure?" "n"; then
          cp "$PERSONAL_AGENTS" "$PERSONAL_AGENTS.backup"
          cp "$KIT_AGENTS" "$PERSONAL_AGENTS"
          ok "~/.codex/AGENTS.md replaced (backup at AGENTS.md.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.codex/AGENTS.md (replacement cancelled)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
    esac
  fi
fi

# ── Step 6: OpenCode ──────────────────────────────────────────────────────────
if [ "$USE_OPENCODE" = true ] && [ -f "$KIT_DIR/agents/opencode/CLAUDE.md" ]; then
  print_section "OpenCode — Global CLAUDE.md"

  OPENCODE_DIR="$HOME/.opencode"
  KIT_OC="$KIT_DIR/agents/opencode/CLAUDE.md"
  PERSONAL_OC="$OPENCODE_DIR/CLAUDE.md"

  mkdir -p "$OPENCODE_DIR"

  if [ ! -f "$PERSONAL_OC" ]; then
    if ask_yn "Install CLAUDE.md into ~/.opencode/?"; then
      cp "$KIT_OC" "$PERSONAL_OC"
      add "~/.opencode/CLAUDE.md (created)"
      CREATED=$((CREATED + 1))
    else
      skip "~/.opencode/CLAUDE.md (skipped)"
      SKIPPED=$((SKIPPED + 1))
    fi
  else
    ask_choice "~/.opencode/CLAUDE.md already exists. What would you like to do?" \
      "Skip — keep mine as-is" \
      "Reference — save as ~/.opencode/CLAUDE.stan.md" \
      "Diff — show differences" \
      "Replace — replace mine (will ask again to confirm)"

    case "$CHOICE" in
      1) skip "~/.opencode/CLAUDE.md (kept existing)"; SKIPPED=$((SKIPPED + 1)) ;;
      2)
        cp "$KIT_OC" "$OPENCODE_DIR/CLAUDE.stan.md"
        add "~/.opencode/CLAUDE.stan.md (reference copy)"
        CREATED=$((CREATED + 1))
        ;;
      3)
        show_diff_then_decide "$PERSONAL_OC" "$KIT_OC"
        if [ "$DIFF_CHOICE" = "replace" ]; then
          cp "$PERSONAL_OC" "$PERSONAL_OC.backup"
          cp "$KIT_OC" "$PERSONAL_OC"
          ok "~/.opencode/CLAUDE.md replaced (backup at CLAUDE.md.backup)"
          CREATED=$((CREATED + 1))
        else
          skip "~/.opencode/CLAUDE.md (kept existing)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
      4)
        warn "This will REPLACE your personal ~/.opencode/CLAUDE.md."
        if ask_yn "  Are you sure?" "n"; then
          cp "$PERSONAL_OC" "$PERSONAL_OC.backup"
          cp "$KIT_OC" "$PERSONAL_OC"
          ok "~/.opencode/CLAUDE.md replaced"
          CREATED=$((CREATED + 1))
        else
          skip "~/.opencode/CLAUDE.md (replacement cancelled)"
          SKIPPED=$((SKIPPED + 1))
        fi
        ;;
    esac
  fi
fi

# ── Done ─────────────────────────────────────────────────────────────────────
print_section "Done"
print_summary "$CREATED" "$SKIPPED" "$MERGED"

info "To update later, just re-run: ./install-global.sh"
echo ""
