#!/bin/bash
# install.sh — Bootstrap ai-dev-kit into an existing or new project
# Usage: ./install.sh [project-path]
#
# Copies templates into the target project.
# Never overwrites files that already exist.

set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT="${1:-.}"

if [ ! -d "$PROJECT" ]; then
  echo "Error: $PROJECT is not a directory."
  exit 1
fi

echo "Installing lokey-dev-kit into: $(cd "$PROJECT" && pwd)"
echo ""

CREATED=0
SKIPPED=0

copy_if_missing() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  mkdir -p "$dst_dir"

  if [ ! -f "$dst" ]; then
    cp "$src" "$dst"
    echo "  + $dst"
    CREATED=$((CREATED + 1))
  else
    echo "  ~ $dst (skipped, already exists)"
    SKIPPED=$((SKIPPED + 1))
  fi
}

echo "--- Commands ---"
copy_if_missing "$KIT_DIR/templates/.claude/commands/start.md"    "$PROJECT/.claude/commands/start.md"
copy_if_missing "$KIT_DIR/templates/.claude/commands/sync-docs.md" "$PROJECT/.claude/commands/sync-docs.md"
copy_if_missing "$KIT_DIR/templates/.claude/commands/release.md"  "$PROJECT/.claude/commands/release.md"
copy_if_missing "$KIT_DIR/templates/.claude/commands/context.md"  "$PROJECT/.claude/commands/context.md"
copy_if_missing "$KIT_DIR/templates/.claude/commands/refactor.md" "$PROJECT/.claude/commands/refactor.md"
copy_if_missing "$KIT_DIR/templates/.claude/commands/devlog.md"   "$PROJECT/.claude/commands/devlog.md"
copy_if_missing "$KIT_DIR/templates/.claude/commands/bootstrap.md" "$PROJECT/.claude/commands/bootstrap.md"

echo ""
echo "--- Settings ---"
copy_if_missing "$KIT_DIR/templates/.claude/settings.json" "$PROJECT/.claude/settings.json"

echo ""
echo "--- Project docs ---"
copy_if_missing "$KIT_DIR/templates/CLAUDE.md"       "$PROJECT/CLAUDE.md"
copy_if_missing "$KIT_DIR/templates/ARCHITECTURE.md" "$PROJECT/ARCHITECTURE.md"

echo ""
echo "--- Doc structure ---"
copy_if_missing "$KIT_DIR/templates/docs/adr/000-template.md" "$PROJECT/docs/adr/000-template.md"
copy_if_missing "$KIT_DIR/templates/docs/prd/INDEX.md"        "$PROJECT/docs/prd/INDEX.md"
copy_if_missing "$KIT_DIR/templates/docs/prd/TEMPLATE.md"     "$PROJECT/docs/prd/TEMPLATE.md"
copy_if_missing "$KIT_DIR/templates/docs/DECISIONS.md"        "$PROJECT/docs/DECISIONS.md"
copy_if_missing "$KIT_DIR/templates/docs/DEVLOG.md"           "$PROJECT/docs/DEVLOG.md"

echo ""
echo "--- Gitignore entries ---"
if [ ! -f "$PROJECT/.gitignore" ]; then
  echo "experiments/" > "$PROJECT/.gitignore"
  echo "  + .gitignore (created with experiments/)"
  CREATED=$((CREATED + 1))
elif ! grep -q "experiments/" "$PROJECT/.gitignore"; then
  echo "" >> "$PROJECT/.gitignore"
  echo "experiments/" >> "$PROJECT/.gitignore"
  echo "  + experiments/ added to .gitignore"
else
  echo "  ~ .gitignore already has experiments/"
fi
mkdir -p "$PROJECT/experiments"

echo ""
echo "────────────────────────────────────"
echo "Created: $CREATED  |  Skipped: $SKIPPED"
echo ""

if [ $CREATED -gt 0 ]; then
  echo "Next steps:"
  if [ -f "$PROJECT/CLAUDE.md" ] && grep -q "TODO" "$PROJECT/CLAUDE.md"; then
    echo "  1. Fill in the TODO sections in CLAUDE.md"
    echo "  2. Fill in ARCHITECTURE.md"
    echo "  3. Customize .claude/commands/start.md with project vocabulary"
  else
    echo "  Review the newly created files and customize as needed."
  fi
fi
