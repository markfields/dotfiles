# dotfiles

**GUID: `4e079e8c-dadd-47fc-9582-0914483981ea`** — grep for this string to locate any installed dotfile on any machine.

Personal dotfiles for a TypeScript / Node.js developer. Optimised for a **fast,
git-aware shell** with plenty of commented-out tutorial sections you can browse
with Copilot and enable a piece at a time.

Inspired by / further reading: <https://dotfiles.github.io/>

---

## What's included

| File | Purpose |
|---|---|
| `.zshrc` | Interactive shell: prompt, history, completion, aliases, functions, tool integrations |
| `.zshenv` | Environment variables loaded by all zsh sessions (PATH, EDITOR, XDG dirs) |
| `.gitconfig` | Git aliases, delta diff, sane defaults |
| `.gitignore_global` | Global ignore patterns (macOS, editors, Node/TS artefacts) |
| `.npmrc` | npm defaults (global prefix, init values) |
| `.editorconfig` | Cross-editor formatting baseline |
| `bootstrap.sh` | Symlinks every file above into `$HOME` |

---

## Quick start

```bash
# 1. Clone
git clone https://github.com/markfields/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Dry run — see what would change
./bootstrap.sh

# 3. Apply
./bootstrap.sh --apply

# 4. Reload
source ~/.zshrc
```

---

## Shell highlights

### Prompt
A single-line prompt built on zsh's native `vcs_info` — no external tools
required.  Shows `user@host ~/path (branch) $` with the exit-status in red on
the right when a command fails.

Alternative prompts are commented in `.zshrc` (Starship, Pure, Oh My Posh).

### History
- 100 000-line history shared across all open terminals in real time
- Prefix-search with ↑ / ↓
- `Ctrl+R` for incremental reverse search (or install fzf for a fuzzy popup)

### Node version management
`fnm` is enabled by default (fast, written in Rust). Alternatives — `nvm`,
`volta`, `asdf` — are all documented and commented in `.zshrc`.

### Key aliases
```
gs   git status -sb          nr   npm run
ga   git add                 nrb  npm run build
gcm  git commit -m           nrd  npm run dev
gl   git log (pretty graph)  nrt  npm run test
gp   git push
```

---

## Extending / customising

### Machine-specific overrides
Create `~/.zshrc.local` and/or `~/.gitconfig.local` — they're sourced
automatically and are never committed to git.

### Enabling a commented section
Most of the interesting stuff in `.zshrc` is commented out as a tutorial.
Search for a section (e.g. `fzf`, `Starship`, `nvm`) and follow the install
instructions in the comment, then un-comment the relevant lines.

### Recommended additions (not installed by default)
| Tool | Install | What it does |
|---|---|---|
| [fzf](https://github.com/junegunn/fzf) | `brew install fzf` | Fuzzy history/file search via `Ctrl+R` |
| [fnm](https://github.com/Schniz/fnm) | `brew install fnm` | Fast Node version manager |
| [git-delta](https://github.com/dandavison/delta) | `brew install git-delta` | Beautiful diffs |
| [eza](https://github.com/eza-community/eza) | `brew install eza` | Modern `ls` with git info |
| [bat](https://github.com/sharkdp/bat) | `brew install bat` | Syntax-highlighted `cat` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `brew install ripgrep` | Fast `grep` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `brew install zoxide` | Smart `cd` |
| [Starship](https://starship.rs) | `brew install starship` | Cross-shell prompt |

---

## Further reading

- <https://dotfiles.github.io/> — community dotfiles tutorials & links
- <https://wiki.archlinux.org/title/Dotfiles> — comprehensive dotfiles guide
- <https://github.com/mathiasbynens/dotfiles> — popular reference dotfiles
- <https://github.com/holman/dotfiles> — Zach Holman's dotfiles (topic-based)
- <https://github.com/thoughtbot/dotfiles> — thoughtbot's dotfiles
