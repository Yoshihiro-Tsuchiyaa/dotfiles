#
<#
# コンソールの文字コードを強制的にUTF-8（65001）に固定
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
#
# 外部の .exe 等が文字化けするのを防ぐため、内部的に chcp 65001 を実行
if ($PSVersionTable.PSVersion.Major -ge 6) {
    & chcp 65001 | Out-Null
}
#>
#
# ~/.config/powershell/Microsoft.PowerShell_profile.ps1 など
#
# ===== ログレベル関数 =====
function LogSuccess {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function LogInfo {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function LogWarn {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function LogError {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

function Die {
    param(
        [string]$Message,
        [int]$ExitCode = 1
    )
    Write-Host $Message -ForegroundColor Red
    exit $ExitCode
}

function LogTime {
    param([string]$Message = "")
    $timestamp = Get-Date -UFormat "%Y/%m/%d %T"
    Write-Host "$timestamp $Message" -ForegroundColor Cyan
}
<#
# ===== 使用例 =====
LogSuccess "処理が成功しました"
LogInfo "情報メッセージです"
LogWarn "警告です"
LogError "エラーが発生しました"
LogTime "タイムスタンプ付きログ"
LogTime "処理開始"
# Die は exit code 1 でプロセス終了
# Die "致命的エラー"

# Die は exit code 2 でプロセス終了
# Die "カスタムエラー" 2
#>

#@oh-my-posh init pwsh | Invoke-Expression
#
#
#
Import-Module lsd-aliases -DisableNameChecking
# ==================================================
# WT_THEME
#
if ($env:TERMINAL_EMULATOR -eq 'WezTerm') {
    LogSuccess '[WezTerm] WezTerm deteced'
    LogSuccess "[WezTerm] WT_THEME=$theme"
} elseif ($env:WT_SESSION) {
    # Windows Terminal settings.json 読み取り
    $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

    $profileId = $env:WT_PROFILE_ID
    $currentProfile = $settings.profiles.list | Where-Object { $_.guid -eq $profileId }

    $theme = $currentProfile.colorScheme
    if (-not $theme) {
        $theme = $settings.profiles.defaults.colorScheme
    }
    $env:WT_THEME = $theme
    LogSuccess "[WT] WT_THEME=$theme"
} else {
}

# ==================================================
Set-Alias -Name vi -Value vim
# ==================================================
function cdh { Set-Location $env:USERPROFILE }
function cdb { Set-Location "$env:USERPROFILE\.local\bin" }
function cdc { Set-Location "$env:USERPROFILE\.local\share\chezmoi" }
function admin { wt -p "PowerShell (管理者)" }
function Test-Admin {
    [bool]([Security.Principal.WindowsPrincipal]::new(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
}
function ConvertTo-GitHubDownloadUrl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Url
    )

    process {
        if (-not [Uri]::TryCreate($Url, [UriKind]::Absolute, [ref]$uri)) {
            throw "有効なURLではありません: $Url"
        }

        $hostName = $uri.Host.ToLowerInvariant()
        $path = $uri.AbsolutePath

        # すでにRaw URLの場合はそのまま返す
        if ($hostName -eq 'raw.githubusercontent.com') {
            $uri.AbsoluteUri
            return
        }

        if ($hostName -ne 'github.com' -and $hostName -ne 'www.github.com') {
            throw "GitHubのURLではありません: $Url"
        }

        # /blob/ または /raw/ を取り除き、Raw用ホストへ変換
        if ($path -notmatch '^/[^/]+/[^/]+/(blob|raw)/.+') {
            throw "GitHubのファイルURLではありません。/blob/ または /raw/ を含むURLを指定してください: $Url"
        }

        $rawPath = $path -replace '^/([^/]+)/([^/]+)/(blob|raw)/', '/$1/$2/'

        "https://raw.githubusercontent.com$rawPath"
    }
}
# ==================================================
#
$isAdmin = Test-Admin
LogSuccess "isAdmin = $isAdmin"
# ==================================================
#
# python:venv
#
$venv = Join-Path $env:USERPROFILE "venv\Scripts\Activate.ps1"
if (Test-Path $venv) {
    LogSuccess "venv setup file found: $venv"
    . $venv
    LogSuccess "where.exe python"
    where.exe python
} else {
    LogWarn "venv setup file not found: $venv"
}
# ==================================================
# clink setup file for editing
#
$clink = Join-Path $env:LOCALAPPDATA "clink\clink_start.cmd"
if (Test-Path $clink) {
    $env:CLINK = $clink
    LogSuccess "CLINK = $clink"
} else {
    LogWarn "clink setup file not found: $clink"
}

