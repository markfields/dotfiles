# dotfiles-guid: 4e079e8c-dadd-47fc-9582-0914483981ea
# =============================================================================
# ~/.zshrc — zsh interactive shell configuration
# =============================================================================
# Optimised for TypeScript / Node.js development.  Fast by default; the many
# commented-out sections are a tutorial you can read with Copilot and
# enable a piece at a time.
#
# References:
#   https://dotfiles.github.io/
#   https://zsh.sourceforge.io/Doc/Release/zsh_toc.html
# =============================================================================


# -----------------------------------------------------------------------------
# 0. PROFILING (uncomment to find what's slow)
# -----------------------------------------------------------------------------
# zmodload zsh/zprof   # start profiling — pair with `zprof` at bottom of file


# =============================================================================
# 1. HISTORY — the single most impactful setting for command recall
# =============================================================================

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=100000          # lines kept in memory
SAVEHIST=100000          # lines written to HISTFILE

setopt HIST_IGNORE_DUPS      # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS  # remove older duplicate entry from history
setopt HIST_FIND_NO_DUPS     # don't show duplicates when searching
setopt HIST_IGNORE_SPACE     # don't record commands starting with a space
setopt HIST_REDUCE_BLANKS    # strip extra blanks
setopt HIST_VERIFY           # show substituted history line before running it
setopt SHARE_HISTORY         # share history across all open shells in real time
setopt INC_APPEND_HISTORY    # write immediately, not on shell exit
setopt EXTENDED_HISTORY      # record timestamp with each command


# =============================================================================
# 2. COMPLETION — fast native zsh completion (no plugins needed)
# =============================================================================

autoload -Uz compinit

# Only rebuild the completion cache once per day (keeps startup snappy)
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+20) ]]; then
  compinit
else
  compinit -C
fi

setopt COMPLETE_IN_WORD   # complete from both ends of a word
setopt AUTO_MENU          # show completion menu on second tab press
setopt LIST_PACKED        # compact the completion list

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Coloured completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Group completions by type (files, commands, etc.)
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'


# =============================================================================
# 3. PROMPT — git-aware, single-line, no external dependencies
# =============================================================================
# Shows: user@host current/dir [branch] $
# Async git info keeps the prompt instant even in big repos.
# See the "ALTERNATIVE PROMPTS" section below for Starship, Pure, etc.

autoload -Uz vcs_info
precmd_functions+=(vcs_info)

zstyle ':vcs_info:git:*' formats       ' %F{cyan}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}(%b|%a)%f'
zstyle ':vcs_info:*'     enable        git

# Prompt format:  user@host ~/path (branch) $
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f %F{blue}%~%f${vcs_info_msg_0_} %# '

# Right-side prompt: last command exit status (hidden when 0)
RPROMPT='%(?..%F{red}✘ %?%f)'

# --- ALTERNATIVE PROMPTS (pick one; comment out the block above) -----------
#
# --- Starship (https://starship.rs) — cross-shell, feature-rich, fast -----
# Install: curl -sS https://starship.rs/install.sh | sh
# eval "$(starship init zsh)"
#
# --- Pure (https://github.com/sindresorhus/pure) — minimal, async ---------
# Install: npm install --global pure-prompt
# autoload -U promptinit; promptinit; prompt pure
#
# --- Oh My Posh (https://ohmyposh.dev) — highly themeable -----------------
# eval "$(oh-my-posh init zsh)"
# ---------------------------------------------------------------------------


# =============================================================================
# 4. KEY BINDINGS — make history search intuitive
# =============================================================================

bindkey -e   # Emacs mode (default, plays well with readline apps)
# bindkey -v # Uncomment for Vi mode

# Up/Down arrows search history by prefix already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search   # tmux / some terminals
bindkey '^[OB' down-line-or-beginning-search

# Ctrl+R — incremental history search (built-in)
bindkey '^R' history-incremental-search-backward

# --- fzf-powered history search (HIGHLY RECOMMENDED) ----------------------
# fzf gives you a fuzzy-searchable history popup — game-changing for recall.
# Install: brew install fzf && $(brew --prefix)/opt/fzf/install
# or:      git clone --depth 1 https://github.com/junegunn/fzf ~/.fzf && ~/.fzf/install
#
# Once installed, sourcing the key bindings file is all you need:
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ---------------------------------------------------------------------------

# Home / End
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Ctrl+Left / Ctrl+Right — jump words
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Ctrl+Backspace / Ctrl+Delete
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word


# =============================================================================
# 5. DIRECTORY NAVIGATION
# =============================================================================

setopt AUTO_CD           # type a directory name to cd into it
setopt AUTO_PUSHD        # cd pushes old directory onto stack
setopt PUSHD_IGNORE_DUPS # no duplicates in directory stack
setopt PUSHD_SILENT      # don't print the stack on each pushd/popd

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'        # cd to previous directory

# --- zoxide (smarter cd — learns your most-visited dirs) ------------------
# Install: brew install zoxide  or  cargo install zoxide
# eval "$(zoxide init zsh)"
# After a while: `z proj` jumps straight to ~/work/my-project
# ---------------------------------------------------------------------------


# =============================================================================
# 6. NODE.JS / TYPESCRIPT TOOLCHAIN
# =============================================================================

# --- Node version manager: choose ONE of the options below ----------------
#
# Option A: fnm  (fast, written in Rust — RECOMMENDED for speed)
# Install: curl -fsSL https://fnm.vercel.app/install | bash
#           or:  brew install fnm
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi
#
# Option B: nvm  (most popular, but adds ~100 ms to every shell startup)
# Install: https://github.com/nvm-sh/nvm#install--update-script
# export NVM_DIR="${HOME}/.nvm"
# [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
# [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
# # Lazy-load nvm to keep startup fast (loads on first `nvm`, `node`, or `npm` call)
# # See: https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/
#
# Option C: volta  (pin per-project, zero-config)
# Install: curl https://get.volta.sh | bash
# export VOLTA_HOME="${HOME}/.volta"
# export PATH="${VOLTA_HOME}/bin:${PATH}"
#
# Option D: asdf  (polyglot version manager — Node, Ruby, Python, Go, …)
# Install: https://asdf-vm.com/guide/getting-started.html
# . "${HOME}/.asdf/asdf.sh"
# . "${HOME}/.asdf/completions/asdf.bash"
# ---------------------------------------------------------------------------

# pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
case ":${PATH}:" in
  *":${PNPM_HOME}:"*) ;;
  *) export PATH="${PNPM_HOME}:${PATH}" ;;
esac

# Corepack / Yarn (comes bundled with Node ≥ 16.9)
# corepack enable   # uncomment to manage yarn/pnpm versions via package.json#packageManager


# =============================================================================
# 7. ALIASES — Node / TypeScript / everyday
# =============================================================================

# --- npm ---
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nu='npm update'
alias nr='npm run'
alias nrb='npm run build'
alias nrd='npm run dev'
alias nrt='npm run test'
alias nrl='npm run lint'
alias nrw='npm run watch'
alias nlg='npm list -g --depth=0'

# --- pnpm (uncomment if you prefer pnpm) ---
# alias pi='pnpm install'
# alias pid='pnpm add -D'
# alias pig='pnpm add -g'
# alias pr='pnpm run'
# alias prb='pnpm run build'
# alias prd='pnpm run dev'
# alias prt='pnpm run test'
# alias prl='pnpm run lint'

# --- TypeScript ---
alias tsc='npx tsc'
alias tsw='npx tsc --watch'
alias tsx='npx tsx'                       # run TS files without compiling first

# --- git (short but readable) ---
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate --all'
alias gll='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias gp='git push'
alias gpf='git push --force-with-lease'  # safer than --force
alias gu='git pull'
alias gst='git stash'
alias gstp='git stash pop'
alias gcp='git cherry-pick'
alias grb='git rebase'
alias gri='git rebase -i'
alias grc='git rebase --continue'

# --- ls / file listing ---
alias ls='ls --color=auto'
alias ll='ls -lAh --color=auto'
alias la='ls -A --color=auto'
# Modern alternatives (install with brew install eza):
# alias ls='eza'
# alias ll='eza -lah --git'
# alias lt='eza --tree --level=2'

# --- safer defaults ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# --- utilities ---
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias ports='lsof -i -P -n | grep LISTEN'  # show listening ports
alias path='echo -e ${PATH//:/\\n}'         # print PATH one entry per line
alias reload='source ~/.zshrc'              # reload this config
alias dotfiles='cd ${DOTFILES_DIR:-~/.dotfiles}'


# =============================================================================
# 8. FUNCTIONS — useful one-liners
# =============================================================================

# Create a directory and immediately cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick git clone and cd
gclone() { git clone "$1" && cd "$(basename "$1" .git)"; }

# Find and kill a process on a given port
killport() {
  local pid
  pid=$(lsof -ti :"$1") && kill -9 "$pid" && echo "Killed PID ${pid} on port $1" \
    || echo "Nothing listening on port $1"
}

# Show the 10 most-used commands (great for finding alias candidates)
topcmds() {
  history 1 | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}

# Extract any archive format
extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1"   ;;
    *.tar.gz)  tar xzf "$1"   ;;
    *.tar.xz)  tar xJf "$1"   ;;
    *.bz2)     bunzip2 "$1"   ;;
    *.gz)      gunzip "$1"    ;;
    *.tar)     tar xf "$1"    ;;
    *.tbz2)    tar xjf "$1"   ;;
    *.tgz)     tar xzf "$1"   ;;
    *.zip)     unzip "$1"     ;;
    *.Z)       uncompress "$1";;
    *.7z)      7z x "$1"      ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
  esac
}

# Open GitHub repo page for the current directory
ghopen() {
  local url
  url=$(git remote get-url origin 2>/dev/null \
    | sed 's|git@github.com:|https://github.com/|' \
    | sed 's|\.git$||')
  [[ -n "$url" ]] && open "$url" || echo "No GitHub remote found"
}


# =============================================================================
# 9. EDITOR
# =============================================================================

export EDITOR='code --wait'   # VS Code; change to nvim/vim/nano as preferred
export VISUAL="${EDITOR}"

# --- Neovim alternatives ---
# export EDITOR='nvim'
# export VISUAL='nvim'


# =============================================================================
# 10. MISCELLANEOUS OPTIONS
# =============================================================================

setopt NO_BEEP           # silence audible bell
setopt INTERACTIVE_COMMENTS  # allow # comments in interactive shell
setopt CORRECT           # suggest corrections for mistyped commands
setopt GLOB_DOTS         # include dotfiles in glob patterns (but not .. /)

# Colour support
export CLICOLOR=1
export LSCOLORS='ExFxBxDxCxegedabagacad'  # macOS ls colours


# =============================================================================
# 11. TOOL INTEGRATIONS (commented-out; install tools then uncomment)
# =============================================================================

# --- Homebrew (macOS / Linux) ---------------------------------------------
# eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# eval "$(/usr/local/bin/brew shellenv)"     # Intel Mac

# --- direnv — per-directory .envrc files ---------------------------------
# Great for project-specific env vars without a plugin manager.
# Install: brew install direnv
# eval "$(direnv hook zsh)"

# --- pyenv — Python version management ------------------------------------
# Install: brew install pyenv
# export PYENV_ROOT="${HOME}/.pyenv"
# export PATH="${PYENV_ROOT}/bin:${PATH}"
# eval "$(pyenv init -)"

# --- rbenv — Ruby version management --------------------------------------
# eval "$(rbenv init - zsh)"

# --- GitHub CLI completions -----------------------------------------------
# brew install gh  →  then:
# eval "$(gh completion -s zsh)"

# --- Docker ---
# export DOCKER_BUILDKIT=1   # faster builds

# --- bat (better cat) — https://github.com/sharkdp/bat -------------------
# Install: brew install bat
# export BAT_THEME="TwoDark"
# alias cat='bat'
# alias man='batman'  # colourised man pages via bat-extras

# --- ripgrep (faster grep) ------------------------------------------------
# Install: brew install ripgrep
# export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"

# --- atuin — magic shell history database ---------------------------------
# Syncs/searches history across machines; replaces Ctrl+R
# Install: bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
# eval "$(atuin init zsh)"

# --- 1Password SSH agent --------------------------------------------------
# export SSH_AUTH_SOCK=~/.1password/agent.sock


# =============================================================================
# 12. PLUGIN MANAGER OPTIONS (all disabled by default for speed)
# =============================================================================
# These are the main options — read, pick one, enjoy.
#
# --- Oh My Zsh (most popular, most plugins, slowest) ----------------------
# Docs: https://ohmyz.sh
# Install: sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# export ZSH="${HOME}/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git node npm yarn typescript vscode fzf)
# source "${ZSH}/oh-my-zsh.sh"
#
# --- Prezto (leaner than OMZ, good defaults) ------------------------------
# Docs: https://github.com/sorin-ionescu/prezto
# source "${ZDOTDIR:-${HOME}}/.zprezto/init.zsh"
#
# --- Zinit (fastest, plugin manager with turbo mode) ----------------------
# Docs: https://github.com/zdharma-continuum/zinit
# Install: bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
# source "${HOME}/.local/share/zinit/zinit.git/zinit.zsh"
# zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
# zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting
# zinit ice wait lucid; zinit light zsh-users/zsh-completions
#
# --- Antidote (successor to antibody, no daemon) --------------------------
# Docs: https://getantidote.github.io
# source "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
# antidote load
#
# --- Sheldon (TOML config, fast) ------------------------------------------
# Docs: https://sheldon.cli.rs
# eval "$(sheldon source)"
#
# --- Manual (no manager; clone repos, source files) -----------------------
# zsh-autosuggestions (Fish-like suggestions): https://github.com/zsh-users/zsh-autosuggestions
# source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# bindkey '^ ' autosuggest-accept   # Ctrl+Space to accept suggestion
#
# zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting
# source "${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# (must be sourced LAST)


# =============================================================================
# 13. LOCAL OVERRIDES — machine-specific settings go here
# =============================================================================
# Keep work/personal secrets and machine-specific paths out of version control.
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"


# --- Profiling results (uncomment if you uncommented zmodload above) ------
# zprof
