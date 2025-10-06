#!/bin/bash
# setup.sh - Install command symlinks for Claude Code and Codex
#
# This script creates symlinks from tool-specific directories to the command files
# in this repository, allowing you to version control your commands in git.
#
# Usage:
#   ./setup.sh           # Auto-detect and set up for all available tools
#   ./setup.sh --claude-code  # Set up for Claude Code only
#   ./setup.sh --codex        # Set up for Codex only
#   ./setup.sh --both         # Set up for both tools

set -e

# Determine script directory and source directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/commands"

# Target directories for each tool
CLAUDE_CODE_DIR="$HOME/.claude/commands"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}/prompts"

# Parse command-line arguments
SETUP_CLAUDE_CODE=""
SETUP_CODEX=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --claude-code|-c)
      SETUP_CLAUDE_CODE="yes"
      shift
      ;;
    --codex|-x)
      SETUP_CODEX="yes"
      shift
      ;;
    --both|-b)
      SETUP_CLAUDE_CODE="yes"
      SETUP_CODEX="yes"
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --claude-code, -c    Set up for Claude Code only"
      echo "  --codex, -x          Set up for Codex only"
      echo "  --both, -b           Set up for both tools"
      echo "  --help, -h           Show this help message"
      echo ""
      echo "If no options are provided, auto-detects available tools."
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"
      echo "Run with --help for usage information"
      exit 1
      ;;
  esac
done

# Auto-detect if no arguments provided
if [ -z "$SETUP_CLAUDE_CODE" ] && [ -z "$SETUP_CODEX" ]; then
  # Check if Claude Code is available
  if [ -d "$HOME/.claude" ] || [ -d "$CLAUDE_CODE_DIR" ]; then
    SETUP_CLAUDE_CODE="yes"
  fi

  # Check if Codex is available
  if [ -d "$HOME/.codex" ] || [ -d "$CODEX_DIR" ] || [ -n "$CODEX_HOME" ]; then
    SETUP_CODEX="yes"
  fi

  # If nothing detected, default to both
  if [ -z "$SETUP_CLAUDE_CODE" ] && [ -z "$SETUP_CODEX" ]; then
    echo "⚠️  No tools detected. Setting up for both Claude Code and Codex."
    SETUP_CLAUDE_CODE="yes"
    SETUP_CODEX="yes"
  fi
fi

echo "🔗 Setting up command symlinks..."
echo ""

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "❌ Error: Source directory not found: $SOURCE_DIR"
  exit 1
fi

# Count files to link
TOTAL_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')

if [ "$TOTAL_FILES" -eq 0 ]; then
  echo "❌ No .md files found in $SOURCE_DIR"
  exit 1
fi

echo "Found $TOTAL_FILES command files to link"
echo ""

# Function to create symlinks for a tool
link_commands() {
  local TOOL_NAME=$1
  local TARGET_DIR=$2
  local LINKED=0
  local SKIPPED=0

  echo "Setting up $TOOL_NAME ($TARGET_DIR):"

  # Create target directory if it doesn't exist
  if [ ! -d "$TARGET_DIR" ]; then
    echo "  📁 Creating $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
  fi

  # Create symlinks for all .md files
  for cmd in "$SOURCE_DIR"/*.md; do
    if [ ! -f "$cmd" ]; then
      continue
    fi

    filename=$(basename "$cmd")
    target="$TARGET_DIR/$filename"

    # Check if symlink already exists and points to the correct location
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$cmd" ]; then
      echo "  ✓ $filename (already linked)"
      SKIPPED=$((SKIPPED + 1))
    else
      # Remove existing file/symlink if it exists
      if [ -e "$target" ] || [ -L "$target" ]; then
        echo "  ⚠️  Replacing existing: $filename"
        rm "$target"
      fi

      # Create symlink
      ln -s "$cmd" "$target"
      echo "  ✅ Linked: $filename"
      LINKED=$((LINKED + 1))
    fi
  done

  echo "  Summary: $LINKED newly linked, $SKIPPED already linked"
  echo ""

  # Return counts via global variables (bash doesn't support returning multiple values easily)
  eval "${TOOL_NAME}_LINKED=$LINKED"
  eval "${TOOL_NAME}_SKIPPED=$SKIPPED"
}

# Set up for Claude Code if requested
if [ "$SETUP_CLAUDE_CODE" = "yes" ]; then
  link_commands "Claude_Code" "$CLAUDE_CODE_DIR"
fi

# Set up for Codex if requested
if [ "$SETUP_CODEX" = "yes" ]; then
  link_commands "Codex" "$CODEX_DIR"
fi

# Final summary
echo "═══════════════════════════════════════════════════════════"
echo "✅ Setup complete!"
echo ""
echo "Summary:"

if [ "$SETUP_CLAUDE_CODE" = "yes" ]; then
  echo "  Claude Code:"
  echo "    - ${Claude_Code_LINKED:-0} files newly linked"
  echo "    - ${Claude_Code_SKIPPED:-0} files already linked"
  echo "    - Location: $CLAUDE_CODE_DIR"
fi

if [ "$SETUP_CODEX" = "yes" ]; then
  echo "  Codex:"
  echo "    - ${Codex_LINKED:-0} files newly linked"
  echo "    - ${Codex_SKIPPED:-0} files already linked"
  echo "    - Location: $CODEX_DIR"
fi

echo ""
echo "Total: $TOTAL_FILES commands available"
echo ""

# Show available commands based on which tools were set up
if [ "$SETUP_CLAUDE_CODE" = "yes" ] && [ "$SETUP_CODEX" = "yes" ]; then
  echo "Commands are now available in both Claude Code and Codex:"
elif [ "$SETUP_CLAUDE_CODE" = "yes" ]; then
  echo "Commands are now available in Claude Code:"
elif [ "$SETUP_CODEX" = "yes" ]; then
  echo "Commands are now available in Codex:"
fi

echo "  /init-context, /role, /session-end, /adr, etc."
echo ""
echo "To update commands: Edit files in $SOURCE_DIR"
echo "To refresh symlinks: Run this script again"
echo "═══════════════════════════════════════════════════════════"
