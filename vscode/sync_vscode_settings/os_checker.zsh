#!/bin/zsh

os_checker() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    local watcher="fswatch"
    local vscode_user_dir="$HOME/Library/Application Support/Code/User"
  else
    echo "Unsupported OS: $OSTYPE"
    exit 1
  fi
  
  echo "$watcher $vscode_user_dir"
}