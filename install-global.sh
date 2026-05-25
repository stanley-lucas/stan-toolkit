#!/bin/bash
# install-global.sh — Install/update global Claude config (~/.claude/)
# Usage: ./install-global.sh
#
# Installs CLAUDE.md and commands into ~/.claude/.
# Commands are always updated (global config should stay in sync with the kit).
# CLAUDE.md is only created if it doesn't exist — edit it manually after.
# settings.json is NEVER touched automatically (permissions are machine-specific).

set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR/commands"

echo "Installing global config into: $CLAUDE_DIR"
echo ""

echo "--- Global CLAUDE.md ---"
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$KIT_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  + ~/.claude/CLAUDE.md (created)"
else
  echo "  ~ ~/.claude/CLAUDE.md already exists."
  echo "    To update: diff $KIT_DIR/global/CLAUDE.md $CLAUDE_DIR/CLAUDE.md"
  echo "    Then merge manually — your local copy may have personalizations."
fi

echo ""
echo "--- Global commands ---"
for cmd in "$KIT_DIR"/global/commands/*.md; do
  name=$(basename "$cmd")
  cp "$cmd" "$CLAUDE_DIR/commands/$name"
  echo "  + ~/.claude/commands/$name"
done

echo ""
echo "--- settings.json ---"
echo "  ! NOT touched automatically."
echo "    Review the hooks in $KIT_DIR/global/settings.json"
echo "    and merge them into ~/.claude/settings.json manually."
echo "    (Permissions are machine-specific and vary per session.)"

echo ""
echo "Done."
