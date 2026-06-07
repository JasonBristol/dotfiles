#!/usr/bin/env bash
set -euo pipefail

# --- move to repo root (directory containing this script) ---
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# --- flags ---
YES=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    -f|--force|--yes) YES=1 ;;
    -n|--dry-run) DRY_RUN=1 ;;
    *) echo "Unknown arg: $arg" >&2; exit 2 ;;
  esac
done

# --- require rsync ---
if ! command -v rsync >/dev/null 2>&1; then
  echo "Error: rsync not found. Install via Homebrew: brew install rsync" >&2
  exit 1
fi

# --- rsync config ---
# Where to back up overwritten files (kept per run)
BACKUP_DIR="$HOME/.bootstrap_backups/$(date -Iseconds)"
mkdir -p "$BACKUP_DIR"

# Exclusions (same as your original, easy to maintain)
read -r -d '' RSYNC_EXCLUDES <<'EOF'
.git/
.DS_Store
.vscode
.travis.yml
bootstrap.sh
setup.sh
brew.sh
brew_cask.sh
README.md
LICENSE
EOF

# Write excludes to a temp file (rsync --exclude-from)
EXCLUDE_FILE="$(mktemp)"
trap 'rm -f "$EXCLUDE_FILE"' EXIT
printf "%s\n" "$RSYNC_EXCLUDES" > "$EXCLUDE_FILE"

# Build rsync options
RSYNC_OPTS=(
  -a  # archive (preserves most metadata)
  -v  # verbose
  -h  # human readable sizes
  --no-perms            # keep target perms (dotfiles typically)
  --exclude-from="$EXCLUDE_FILE"
  --backup              # keep a copy of replaced files
  --backup-dir="$BACKUP_DIR"
)

# Optional dry run
if [[ $DRY_RUN -eq 1 ]]; then
  RSYNC_OPTS+=(--dry-run)
  echo "🔎 Dry run mode: showing what would change…"
fi

do_sync() {
  rsync "${RSYNC_OPTS[@]}" . "$HOME/"
}

# --- confirmation prompt unless --yes/--force ---
if [[ $YES -eq 1 ]]; then
  do_sync
else
  read -r -p "This may overwrite files in your home directory. Proceed? (y/N) " reply
  echo ""
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    do_sync
  else
    echo "Aborted."
    exit 0
  fi
fi

# --- post-sync: reload shell config for current user shell ---
CURRENT_SHELL="$(basename "${SHELL:-}")"
case "$CURRENT_SHELL" in
  zsh)
    # Reload zsh login environment
    if [[ $DRY_RUN -eq 0 ]]; then
      exec zsh -l
    fi
    ;;
  bash)
    if [[ $DRY_RUN -eq 0 ]]; then
      exec bash -l
    fi
    ;;
  *)
    echo "ℹ️  Files synced. Open a new terminal to load changes (shell: $CURRENT_SHELL)."
    ;;
esac