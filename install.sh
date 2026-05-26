#!/usr/bin/env bash
# =============================================================================
# install.sh — bootstrap dotfiles by symlinking them into $HOME
# =============================================================================
# Usage:
#   ./install.sh          # dry run (shows what would happen)
#   ./install.sh --apply  # actually create symlinks
#
# What it does:
#   • Symlinks every file listed in FILES below from this repo into $HOME
#   • Backs up any existing files to <file>.backup.<timestamp>
#   • Is idempotent — safe to run multiple times
#
# Alternative tools to consider for managing dotfiles:
#   • GNU Stow    — https://www.gnu.org/software/stow/           (simple, symlink-based)
#   • chezmoi     — https://www.chezmoi.io/                      (templates, encryption)
#   • YADM        — https://yadm.io/                             (git wrapper)
#   • Dotbot      — https://github.com/anishathalye/dotbot       (YAML config)
#   • Mackup      — https://github.com/lra/mackup                (syncs app settings too)
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"
APPLY=false

# Colour helpers
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}  →${RESET} $*"; }
success() { echo -e "${GREEN}  ✓${RESET} $*"; }
warning() { echo -e "${YELLOW}  !${RESET} $*"; }
error()   { echo -e "${RED}  ✗${RESET} $*" >&2; }

# Parse args
for arg in "$@"; do
  case "$arg" in
    --apply|-a) APPLY=true ;;
    --help|-h)
      echo "Usage: $(basename "$0") [--apply]"
      echo "  Without --apply, performs a dry run."
      exit 0
      ;;
    *) error "Unknown argument: $arg"; exit 1 ;;
  esac
done

# =============================================================================
# FILES TO SYMLINK  (source path relative to DOTFILES_DIR → target in $HOME)
# =============================================================================
declare -A FILES=(
  [".zshrc"]=".zshrc"
  [".zshenv"]=".zshenv"
  [".gitconfig"]=".gitconfig"
  [".gitignore_global"]=".gitignore_global"
  [".npmrc"]=".npmrc"
  [".editorconfig"]=".editorconfig"
)

# =============================================================================
# MAIN
# =============================================================================

echo
echo -e "${BOLD}dotfiles installer${RESET} — ${DOTFILES_DIR}"
if [[ "${APPLY}" == false ]]; then
  echo -e "${YELLOW}DRY RUN — pass --apply to make changes${RESET}"
fi
echo

link_file() {
  local src="${DOTFILES_DIR}/${1}"
  local dst="${HOME}/${2}"

  if [[ ! -e "$src" ]]; then
    error "Source not found: $src"
    return
  fi

  # Already correctly linked
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    success "${dst} → already linked"
    return
  fi

  # Backup existing file/symlink
  if [[ -e "$dst" || -L "$dst" ]]; then
    warning "Backing up ${dst} → ${dst}${BACKUP_SUFFIX}"
    if [[ "${APPLY}" == true ]]; then
      mv "$dst" "${dst}${BACKUP_SUFFIX}"
    fi
  fi

  info "Linking ${dst} → ${src}"
  if [[ "${APPLY}" == true ]]; then
    ln -sf "$src" "$dst"
  fi
}

for src in "${!FILES[@]}"; do
  link_file "$src" "${FILES[$src]}"
done

echo
if [[ "${APPLY}" == true ]]; then
  echo -e "${GREEN}${BOLD}Done!${RESET} Dotfiles installed."
  echo "  Reload your shell:  source ~/.zshrc"
else
  echo -e "Run ${BOLD}./install.sh --apply${RESET} to apply the above changes."
fi
echo
