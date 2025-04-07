#!/bin/zsh

check_pid() {
  local pid="$1"
  if ps -p "$pid" > /dev/null 2>&1; then
    echo "PID $pid is in use."
  else
    echo "PID $pid is not in use."
  fi
}

# PIDファイルのパス
PID_FILE="/tmp/vscode_sync.pid"

# PIDファイルが存在するかチェック
if [[ -f "$PID_FILE" ]]; then
  existing_pid=$(cat "$PID_FILE")
  check_output=$(check_pid "$existing_pid")
  if [[ "$check_output" == *"is in use"* ]]; then
    echo "Process with PID $existing_pid is already running. Not starting run.zsh."
    exit 0
  else
    echo "Stale PID file found (PID $existing_pid not in use). Removing."
    rm -f "$PID_FILE"
  fi
fi

echo "Starting run.zsh..."
# run.zsh をバックグラウンドで起動し、その PID をPIDファイルに記録する
source ~/dotfiles/vscode/sync_vscode_settings/windows/run.zsh >> nohup.out 2>&1 &
new_pid=$!
echo "$new_pid" > "$PID_FILE"
echo "run.zsh started with PID $new_pid."

wait
