#!/usr/bin/env bash
set -euo pipefail

# --- Sudo upfront (keep alive) -----------------------------------------------
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- Create dev directories ---------------------------------------------------
mkdir -p "$HOME/Projects" "$HOME/Virtualenvs"
sudo chown -R "$USER" "$HOME/Projects" "$HOME/Virtualenvs"

# --- Install Homebrew if missing (official installer) ------------------------
if ! command -v brew >/dev/null 2>&1; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew in PATH for this session (Apple Silicon vs Intel)
if [[ -d /opt/homebrew/bin ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /usr/local/bin ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Run your brew bundles (updated scripts you maintain) --------------------
# Expect these to contain the modernized one-per-line brew installs.
if [[ -f ./brew.sh ]]; then bash ./brew.sh; fi
if [[ -f ./brew_cask.sh ]]; then bash ./brew_cask.sh; fi

# --- Shell theme (Oh My Zsh) -------------------------------------------------
# Quietly fetch theme; skip if Oh My Zsh not present
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  curl -fsSL -o "$HOME/.oh-my-zsh/themes/aphrodite.zsh-theme" https://git.io/v5ohc || true
fi

# --- Symlink dotfiles / bootstrap --------------------------------------------
if [[ -f ./bootstrap.sh ]]; then bash ./bootstrap.sh; fi

# --- Git LFS (one-time) ------------------------------------------------------
if command -v git-lfs >/dev/null 2>&1; then
  git lfs install --system || git lfs install || true
fi

# --- asdf Node.js setup (replaces nvm) ----------------------------------------
# Node is managed via asdf; see asdf plugin installs below after Ruby

# --- asdf init ---------------------------------------------------------------
if brew list asdf >/dev/null 2>&1; then
  if ! grep -q 'asdf.sh' "$HOME/.zshrc" 2>/dev/null; then
    echo ". \"$(brew --prefix asdf)/libexec/asdf.sh\"" >> "$HOME/.zshrc"
  fi
  # shellcheck source=/dev/null
  . "$(brew --prefix asdf)/libexec/asdf.sh"
  # Pre-add common plugin you referenced earlier (safe if already added)
  asdf plugin add java 2>/dev/null || true
fi

# --- Java (Temurin 21 via asdf) ----------------------------------------------
if command -v asdf >/dev/null 2>&1; then
  # Ensure plugin exists (no-op if present)
  asdf plugin add java 2>/dev/null || true

  # Find the newest Temurin 21 available
  LATEST_TEMURIN_21="$(asdf list all java | awk '/^temurin-21(\.|$)/ {print $1}' | tail -1 || true)"
  if [[ -z "${LATEST_TEMURIN_21:-}" ]]; then
    LATEST_TEMURIN_21="temurin-21"
  fi

  asdf install java "${LATEST_TEMURIN_21}" || true
  asdf global java "${LATEST_TEMURIN_21}"
  asdf reshim java
  # Verify (non-fatal)
  command -v java >/dev/null 2>&1 && java -version || true
fi

# --- Ruby (via asdf) ---------------------------------------------------------
if command -v asdf >/dev/null 2>&1; then
  asdf plugin add ruby 2>/dev/null || true

  # get latest 3.x line (e.g., 3.3.x)
  LATEST_RUBY="$(asdf latest ruby '3.*' 2>/dev/null || true)"
  [[ -z "${LATEST_RUBY:-}" ]] && LATEST_RUBY="$(asdf latest ruby 2>/dev/null || true)"
  [[ -z "${LATEST_RUBY:-}" ]] && LATEST_RUBY="3.3.0"  # conservative fallback

  asdf install ruby "$LATEST_RUBY" || true
  asdf global ruby "$LATEST_RUBY"
  asdf reshim ruby

  # ensure gem bin dir is on PATH for current session
  export GEM_HOME="$HOME/.gem"
  export PATH="$GEM_HOME/bin:$PATH"

  # baseline gems for iOS/React Native workflows
  gem update --system --no-document || true
  gem install bundler --no-document || true
fi

# --- Additional asdf language plugins ----------------------------------------
if command -v asdf >/dev/null 2>&1; then
  # Node.js (LTS)
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
  asdf install nodejs latest:lts || true
  asdf global nodejs latest:lts || true
  corepack enable || true

  # Erlang
  asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git 2>/dev/null || true
  asdf install erlang latest || true
  asdf global erlang latest || true

  # Elixir (depends on Erlang)
  asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git 2>/dev/null || true
  asdf install elixir latest || true
  asdf global elixir latest || true

  # Clojure
  asdf plugin add clojure https://github.com/asdf-community/asdf-clojure.git 2>/dev/null || true
  asdf install clojure latest || true
  asdf global clojure latest || true

  # Haskell (GHC)
  asdf plugin add haskell https://github.com/vic/asdf-haskell.git 2>/dev/null || true
  asdf install haskell latest || true
  asdf global haskell latest || true

  # Nim
  asdf plugin add nim https://github.com/asdf-community/asdf-nim.git 2>/dev/null || true
  asdf install nim latest || true
  asdf global nim latest || true

  # Deno
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git 2>/dev/null || true
  asdf install deno latest || true
  asdf global deno latest || true

  # Python 3
  asdf plugin add python https://github.com/danhper/asdf-python.git 2>/dev/null || true
  asdf install python latest:3 || true
  asdf global python latest:3 || true

  # Lua
  asdf plugin add lua https://github.com/Stratus3D/asdf-lua.git 2>/dev/null || true
  asdf install lua latest || true
  asdf global lua latest || true
fi

# --- Rust toolchains (prefer rustup over brew rust) --------------------------
if command -v rustup >/dev/null 2>&1; then
  true
elif brew list rustup >/dev/null 2>&1 || brew list rustup-init >/dev/null 2>&1 || command -v rustup-init >/dev/null 2>&1; then
  rustup-init -y
else
  # Fallback to official installer if rustup not present
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# shellcheck source=/dev/null
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# --- Sonic Pi CLI (optional) -------------------------------------------------
if command -v cargo >/dev/null 2>&1; then
  cargo install --git https://github.com/lpil/sonic-pi-tool/ || true
fi

# --- Poetry (modern installer) -----------------------------------------------
if ! command -v poetry >/dev/null 2>&1; then
  curl -sSL https://install.python-poetry.org | python3 -
  if ! grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  fi
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- CocoaPods via asdf Ruby -------------------------------------------------
if command -v asdf >/dev/null 2>&1; then
  # make sure ruby shims are active in this shell
  . "$(brew --prefix asdf)/libexec/asdf.sh"
  if ! command -v pod >/dev/null 2>&1; then
    gem install cocoapods --no-document
    asdf reshim ruby
  fi
  pod setup || true
fi

# --- Flutter (stable channel) ------------------------------------------------
if [[ ! -d "$HOME/Documents/flutter" ]]; then
  git clone -b stable https://github.com/flutter/flutter.git "$HOME/Documents/flutter" --single-branch
fi
if ! grep -q 'Documents/flutter/bin' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="$HOME/Documents/flutter/bin:$PATH"' >> "$HOME/.zshrc"
fi
export PATH="$HOME/Documents/flutter/bin:$PATH"
flutter doctor --android-licenses || true
flutter doctor || true

# --- Databases & services -----------------------------------------------------
if brew list postgresql >/dev/null 2>&1; then brew services start postgresql || true; fi
if brew list mysql >/dev/null 2>&1; then brew services start mysql || true; fi
if brew list redis >/dev/null 2>&1; then brew services start redis || true; fi
if brew list "mongodb-community@8.0" >/dev/null 2>&1; then brew services start mongodb-community@8.0 || true; fi
if brew list neo4j >/dev/null 2>&1; then brew services start neo4j || true; fi

# --- Watchman tuning (best-effort) -------------------------------------------
if command -v watchman >/dev/null 2>&1; then
  mkdir -p "$HOME/Library/LaunchAgents"
  defaults write com.apple.watchman settings -dict max_files 122880 || true
fi

# --- Mackup (dotfiles backup) ------------------------------------------------
if command -v mackup >/dev/null 2>&1; then
  mackup backup -f || true
fi

# --- macOS defaults -----------------------------------------------------------
if [[ -f ./.macos ]]; then bash ./.macos; fi

echo "✅ Bootstrap complete. Open a new terminal tab to load updated PATH."
