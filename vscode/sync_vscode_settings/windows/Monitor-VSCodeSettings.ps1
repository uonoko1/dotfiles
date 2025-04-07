# Monitor-VSCodeSettings.ps1

# 送信先の HTTP エンドポイント（WSL2 上の Web サーバーのアドレス）
$endpoint = "http://localhost:65535/sync"

# グローバル変数にエンドポイントをセット
$global:syncEndpoint = $endpoint

function Monitor-File {
    param (
        [string]$FilePath,
        [string]$Endpoint  # もはや使用しなくてもよい
    )
    
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = Split-Path $FilePath
    Write-Host "Watching path: $($watcher.Path)" -ForegroundColor Green
    $watcher.Filter = Split-Path $FilePath -Leaf
    Write-Host "Watching file: $($watcher.Filter)" -ForegroundColor Green

    # Changed と Renamed イベントを監視する（必要に応じて他の NotifyFilters も追加）
    $watcher.NotifyFilter = [System.IO.NotifyFilters]'LastWrite, FileName, Size'

    # Changed イベントの登録
    Register-ObjectEvent $watcher "Changed" -Action {
        Write-Host "File changed: $changedFile" -ForegroundColor Yellow
        try {
            Invoke-RestMethod -Method Post -Uri $global:syncEndpoint -ContentType "application/json"
            Write-Host "POST request sent to $global:syncEndpoint" -ForegroundColor Green
        } catch {
            Write-Host "Failed to send POST request: $_" -ForegroundColor Red
        }
    } | Out-Null

    # Renamed イベントの登録
    Register-ObjectEvent $watcher "Renamed" -Action {
        Write-Host "File renamed: $changedFile" -ForegroundColor Yellow
        try {
            Invoke-RestMethod -Method Post -Uri $global:syncEndpoint -ContentType "application/json"
            Write-Host "POST request sent to $global:syncEndpoint" -ForegroundColor Green
        } catch {
            Write-Host "Failed to send POST request: $_" -ForegroundColor Red
        }
    } | Out-Null

    $watcher.EnableRaisingEvents = $true
    Write-Host "Started monitoring $FilePath" -ForegroundColor Cyan
}

# 監視対象ファイルのパス
$settingsPath   = "$env:USERPROFILE\AppData\Roaming\Code\User\settings.json"
$keybindingsPath = "$env:USERPROFILE\AppData\Roaming\Code\User\keybindings.json"

Write-Host "Monitoring $settingsPath and $keybindingsPath for changes..." -ForegroundColor Cyan

# 監視の開始
Monitor-File -FilePath $settingsPath -Endpoint $endpoint
Monitor-File -FilePath $keybindingsPath -Endpoint $endpoint

Write-Host "Monitoring VSCode settings files. Press Ctrl+C to exit." -ForegroundColor Magenta

while ($true) { Start-Sleep -Seconds 1 }