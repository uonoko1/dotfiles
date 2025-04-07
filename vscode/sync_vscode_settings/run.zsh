#!/bin/zsh

source ~/dotfiles/vscode/sync_vscode_settings/os_checker.zsh
source ~/dotfiles/vscode/sync_vscode_settings/sync_file.zsh
read watcher vscode_user_dir <<< "$(os_checker)"
local target_dir="$HOME/dotfiles/vscode"

echo "vscode_user_dir: $vscode_user_dir"
echo "target_dir: $target_dir"
echo "watcher: $watcher"

sync_file "$vscode_user_dir/settings.json" "$target_dir/settings.json" "$watcher" &
sync_file "$vscode_user_dir/keybindings.json" "$target_dir/keybindings.json" "$watcher" &

wait