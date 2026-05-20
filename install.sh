#!/usr/bin/env bash

set -euo pipefail

SKILL_NAME="common-official-document-format"
TARGET="auto"
FORCE="0"

usage() {
  cat <<'EOF'
Usage:
  bash install.sh [--target auto|codex|claude|openclaw] [--force]

Examples:
  bash install.sh --target codex
  bash install.sh --target claude
  bash install.sh --target openclaw
  bash install.sh --target auto --force
EOF
}

info() { printf '%s\n' "==> $*"; }
ok() { printf '%s\n' "[OK] $*"; }
err() { printf '%s\n' "[ERROR] $*" >&2; }

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --target=*)
      TARGET="${1#*=}"
      shift
      ;;
    --force)
      FORCE="1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      err "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

resolve_target() {
  case "$TARGET" in
    auto)
      if [ -n "${CODEX_HOME:-}" ] || [ -d "$HOME/.codex" ]; then
        printf '%s\n' "codex"
      elif [ -d "$HOME/.claude" ]; then
        printf '%s\n' "claude"
      else
        printf '%s\n' "codex"
      fi
      ;;
    codex|claude|openclaw)
      printf '%s\n' "$TARGET"
      ;;
    *)
      err "Unsupported target: $TARGET"
      usage
      exit 1
      ;;
  esac
}

install_root_for() {
  case "$1" in
    codex)
      printf '%s\n' "${CODEX_HOME:-$HOME/.codex}/skills"
      ;;
    claude)
      printf '%s\n' "$HOME/.claude/skills"
      ;;
    openclaw)
      printf '%s\n' "$HOME/skills"
      ;;
  esac
}

copy_skill() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ]; then
    if [ "$FORCE" != "1" ]; then
      err "Destination already exists: $dest"
      err "Re-run with --force to replace it."
      exit 1
    fi
    rm -rf "$dest"
  fi

  mkdir -p "$dest"
  cp "$src/SKILL.md" "$dest/SKILL.md"
  if [ -d "$src/agents" ]; then
    mkdir -p "$dest/agents"
    cp "$src/agents/openai.yaml" "$dest/agents/openai.yaml"
  fi
}

main() {
  local script_dir install_target install_root dest
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [ ! -f "$script_dir/SKILL.md" ]; then
    err "SKILL.md not found next to install.sh"
    exit 1
  fi

  install_target="$(resolve_target)"
  install_root="$(install_root_for "$install_target")"
  dest="$install_root/$SKILL_NAME"

  info "Target: $install_target"
  info "Install path: $dest"

  copy_skill "$script_dir" "$dest"

  ok "Installed $SKILL_NAME to $dest"
  info "Restart your AI tool so it can load the skill."
}

main "$@"
