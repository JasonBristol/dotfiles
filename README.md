# dotfiles

macOS Ventura (13.x) dotfiles for a 2017 Intel Mac. Based on [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles).

## Install

```bash
./setup.sh      # Full setup: Homebrew, packages, asdf runtimes, dotfiles, macOS prefs
./bootstrap.sh  # Dotfiles only (rsync to $HOME with timestamped backup)
./.macos        # macOS system preferences only
```

## What's included

- **Shell**: zsh + Oh My Zsh (aphrodite theme), sourcing `.aliases`, `.functions`, `.exports`, `.extra`
- **Packages**: see `brew.sh` (formulae) and `brew_cask.sh` (apps)
- **Runtimes**: managed via [asdf](https://asdf-vm.com) — Node, Ruby, Java, Python, Erlang, Elixir, Clojure, Nim, Deno, Lua, Haskell
- **Config**: `.gitconfig`, `.vimrc`, `.tmux.conf`, `.inputrc`
- **macOS**: `.macos` sets system preferences for Finder, Dock, Safari, Terminal, and more
