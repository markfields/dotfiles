# =============================================================================
# ~/.zshenv — sourced by ALL zsh instances (login, interactive, scripts)
# =============================================================================
# Keep this file lean and fast.  Only put things here that genuinely need to
# be available in every shell context (e.g. $PATH, $EDITOR, $LANG).
#
# For interactive-shell-only settings, use ~/.zshrc instead.
# For login-shell-only settings, use ~/.zprofile instead.
# =============================================================================


# -----------------------------------------------------------------------------
# LANGUAGE / LOCALE
# -----------------------------------------------------------------------------

export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'


# -----------------------------------------------------------------------------
# XDG BASE DIRECTORIES (https://specifications.freedesktop.org/basedir-spec/)
# Keeps your $HOME tidy — many modern tools respect these.
# -----------------------------------------------------------------------------

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"


# -----------------------------------------------------------------------------
# PATH — add your own bins before the system ones
# -----------------------------------------------------------------------------

# Local user binaries (scripts you want available everywhere)
export PATH="${HOME}/.local/bin:${PATH}"

# Homebrew (uncomment whichever applies)
# export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"   # Apple Silicon
# export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"         # Intel Mac

# Global npm binaries (fallback if a version manager isn't managing PATH)
# export PATH="${HOME}/.npm-global/bin:${PATH}"


# -----------------------------------------------------------------------------
# DOTFILES LOCATION — used by the `dotfiles` alias in .zshrc
# -----------------------------------------------------------------------------

export DOTFILES_DIR="${HOME}/.dotfiles"


# -----------------------------------------------------------------------------
# EDITOR / PAGER
# -----------------------------------------------------------------------------

export EDITOR='code --wait'
export VISUAL="${EDITOR}"
export PAGER='less'

# Less options: case-insensitive search, quit if short, use colour, show %
export LESS='-iRFX --use-color'

# Use bat as a colourised pager for man pages (requires bat to be installed)
# export MANPAGER='sh -c "col -bx | bat -l man -p"'


# -----------------------------------------------------------------------------
# DEVELOPMENT TOOLS
# -----------------------------------------------------------------------------

# Node / npm
export NPM_CONFIG_PREFIX="${HOME}/.npm-global"   # global npm install location

# TypeScript / ts-node
# export TS_NODE_PROJECT='tsconfig.json'

# Go (if you ever dabble)
# export GOPATH="${HOME}/go"
# export PATH="${GOPATH}/bin:${PATH}"

# Rust / Cargo
# export PATH="${HOME}/.cargo/bin:${PATH}"

# Python (pyenv)
# export PYENV_ROOT="${HOME}/.pyenv"
# export PATH="${PYENV_ROOT}/bin:${PATH}"


# -----------------------------------------------------------------------------
# LOCAL OVERRIDES — machine-specific env vars (not committed to git)
# -----------------------------------------------------------------------------
[[ -f "${HOME}/.zshenv.local" ]] && source "${HOME}/.zshenv.local"
