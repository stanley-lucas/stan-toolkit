#!/bin/bash
# lib/ui.sh — Shared UI primitives for sarcorps-toolkit installers

# ── Colors ──────────────────────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

BG_BLACK='\033[40m'
BG_BLUE='\033[44m'

# ── Symbols ──────────────────────────────────────────────────────────────────
SYM_OK="✓"
SYM_SKIP="~"
SYM_ADD="+"
SYM_WARN="!"
SYM_ERR="✗"
SYM_ARROW="→"

# ── Banner ───────────────────────────────────────────────────────────────────
print_banner() {
  local title="${1:-SARCORPS TOOLKIT}"
  local subtitle="${2:-}"
  local width=52

  echo ""
  printf "${BOLD}${BG_BLUE}${WHITE}%${width}s${RESET}\n" ""
  printf "${BOLD}${BG_BLUE}${WHITE}  %-$((width - 2))s${RESET}\n" "$title"
  if [ -n "$subtitle" ]; then
    printf "${BG_BLUE}${WHITE}  %-$((width - 2))s${RESET}\n" "$subtitle"
  fi
  printf "${BOLD}${BG_BLUE}${WHITE}%${width}s${RESET}\n" ""
  echo ""
}

# ── Section header ───────────────────────────────────────────────────────────
print_section() {
  echo ""
  printf "${BOLD}${CYAN}── %s ${DIM}%s${RESET}\n" "$1" "$(printf '─%.0s' {1..40})" | head -c 60
  printf "${BOLD}${CYAN}── %s ${RESET}\n" "$1"
}

# ── Status lines ─────────────────────────────────────────────────────────────
ok()   { printf "  ${GREEN}${SYM_OK}${RESET}  %s\n" "$1"; }
skip() { printf "  ${DIM}${SYM_SKIP}${RESET}  ${DIM}%s${RESET}\n" "$1"; }
add()  { printf "  ${GREEN}${SYM_ADD}${RESET}  ${BOLD}%s${RESET}\n" "$1"; }
warn() { printf "  ${YELLOW}${SYM_WARN}${RESET}  ${YELLOW}%s${RESET}\n" "$1"; }
err()  { printf "  ${RED}${SYM_ERR}${RESET}  ${RED}%s${RESET}\n" "$1"; }
info() { printf "  ${BLUE}${SYM_ARROW}${RESET}  %s\n" "$1"; }

# ── Divider ──────────────────────────────────────────────────────────────────
divider() {
  printf "  ${DIM}%s${RESET}\n" "────────────────────────────────────────"
}

# ── Prompt: yes/no ───────────────────────────────────────────────────────────
# Usage: ask_yn "Question?" [default: y|n]
# Returns 0 for yes, 1 for no
ask_yn() {
  local question="$1"
  local default="${2:-y}"
  local prompt

  if [ "$default" = "y" ]; then
    prompt="${BOLD}[Y/n]${RESET}"
  else
    prompt="${BOLD}[y/N]${RESET}"
  fi

  printf "\n  ${BOLD}%s${RESET} %b " "$question" "$prompt"
  read -r answer
  answer="${answer:-$default}"

  case "$answer" in
    [Yy]*) return 0 ;;
    *)     return 1 ;;
  esac
}

# ── Prompt: multi-choice ─────────────────────────────────────────────────────
# Usage: ask_choice "Question?" "Option A" "Option B" "Option C"
# Sets CHOICE to the selected index (1-based). Returns 0.
ask_choice() {
  local question="$1"
  shift
  local options=("$@")

  printf "\n  ${BOLD}%s${RESET}\n" "$question"
  for i in "${!options[@]}"; do
    printf "    ${CYAN}%d${RESET}) %s\n" "$((i + 1))" "${options[$i]}"
  done
  printf "\n  ${BOLD}Choice [1-%d]:${RESET} " "${#options[@]}"
  read -r CHOICE

  if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#options[@]}" ]; then
    CHOICE=1
  fi
}

# ── Prompt: multi-select (space to toggle, enter to confirm) ─────────────────
# Usage: ask_multiselect "Question?" "Option A" "Option B" ...
# Sets SELECTED as space-separated list of selected indices (1-based)
ask_multiselect() {
  local question="$1"
  shift
  local options=("$@")
  local selected=()

  printf "\n  ${BOLD}%s${RESET}\n" "$question"
  printf "  ${DIM}Enter numbers separated by spaces (e.g. 1 3):${RESET}\n"
  for i in "${!options[@]}"; do
    printf "    ${CYAN}%d${RESET}) %s\n" "$((i + 1))" "${options[$i]}"
  done
  printf "\n  ${BOLD}Selection:${RESET} "
  read -r -a raw

  SELECTED=""
  for val in "${raw[@]}"; do
    if [[ "$val" =~ ^[0-9]+$ ]] && [ "$val" -ge 1 ] && [ "$val" -le "${#options[@]}" ]; then
      SELECTED="$SELECTED $val"
    fi
  done
  SELECTED="${SELECTED# }"
}

# ── Prompt: show diff between two files ──────────────────────────────────────
show_diff() {
  local existing="$1"
  local incoming="$2"

  echo ""
  if command -v diff >/dev/null 2>&1; then
    diff --color=always -u "$existing" "$incoming" 2>/dev/null || true
  else
    warn "diff not available — open both files manually to compare"
    info "Existing : $existing"
    info "Incoming : $incoming"
  fi
  echo ""
}

# ── Summary block ─────────────────────────────────────────────────────────────
print_summary() {
  local created="$1"
  local skipped="$2"
  local merged="$3"

  echo ""
  divider
  printf "  ${GREEN}${SYM_OK} Created${RESET}  ${BOLD}%s${RESET}   " "$created"
  printf "${DIM}${SYM_SKIP} Skipped${RESET}  ${BOLD}%s${RESET}   " "$skipped"
  if [ -n "$merged" ] && [ "$merged" != "0" ]; then
    printf "${CYAN}⇄ Merged${RESET}  ${BOLD}%s${RESET}" "$merged"
  fi
  echo ""
  divider
  echo ""
}
