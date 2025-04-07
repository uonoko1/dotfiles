#!/bin/zsh

sync_file() {
  local source_file="$1"
  local target_file="$2"
  local watcher="$3"
  
    if ! command -v fswatch >/dev/null; then
      echo "Error: fswatch is not installed. Aborting."
      return 1
    fi

    echo "Start watching $source_file with fswatch..."
    
    fswatch -o "$source_file" | while read count; do
      rsync -av "$source_file" "$target_file"
      echo "$(basename "$source_file") synchronized at $(date)"
    done
}