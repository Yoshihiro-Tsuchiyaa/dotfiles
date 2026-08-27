# MakeLink.ps1

$destRoot  = "C:\Tools\bin"
$wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"

# 除外（uutils.coreutils）
$exclude = "uutils.coreutils"

# NameMap 読み込み
. "$PSScriptRoot\NameMap.ps1"

# Write-Host "=== MakeLink.ps1 ==="

# Winget Packages 以下の exe を取得（除外あり）
$exeFiles = Get-ChildItem -Path $wingetRoot -Recurse -Filter *.exe |
            Where-Object { $_.FullName -notmatch $exclude }

foreach ($exe in $exeFiles) {

    $originalName = $exe.Name

    #
    # NameMap に originalName があるか？
    #
    $shortName = $NameMap.Keys | Where-Object { $NameMap[$_] -eq $originalName }

    # 読み替えテーブルに無い場合は originalName を shortName として使う
    if (-not $shortName) {
        $shortName = $originalName
    }

    #
    # Tools/bin 側のパス
    #
    $destPath = Join-Path $destRoot $shortName

    #
    # STALE 判定
    #
    $needUpdate = $false

    if (Test-Path $destPath) {

        # ハードリンクリスト取得（短いパスが返る可能性あり）
        $rawLinks = fsutil hardlink list $destPath 2>$null
        $rawLinks = $rawLinks | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        # fsutil の短いパスを長いパスに正規化
        $normalizedLinks = foreach ($link in $rawLinks) {
            try {
                (Get-Item $link).FullName
            } catch {
                # 取得できない場合はそのまま
                $link
            }
        }

        # Winget 側の実体そのもの
        $expectedWingetPath = $exe.FullName

        # STALE 判定：リンク先が Winget の新しい実体を指していない
        if ($normalizedLinks -notcontains $expectedWingetPath) {
            $needUpdate = $true
        }

    } else {
        # shortName が存在しない → 新規作成が必要
        $needUpdate = $true
    }

    #
    # STALE または未作成 → rename + 新規作成
    #
    if ($needUpdate) {

        if (Test-Path $destPath) {
Write-Host "Test-Path $destPath:True"
            # 元の shortName のバージョン情報を使う
            $ver = (Get-Item $destPath).VersionInfo.ProductVersion
            if (-not $ver) { $ver = "unknown" }

            $backupName = "$($shortName)_$ver.exe.old"

            Rename-Item -Path $destPath -NewName $backupName -Force
Write-Host "destPath=$destPath"
Write-Host "backupName=$backupName"
            # 古い shortName のハードリンクを削除（unlink）
            Remove-Item $destPath -Force

            Write-Host "[RENAME] $shortName → $backupName"
        }

        # 新しいハードリンクを作成
        New-Item -ItemType HardLink -Path $destPath -Target $exe.FullName | Out-Null
        Write-Host "[LINKED] $shortName → $($exe.FullName)"

    } else {

#        Write-Host "[SKIP] $shortName (正常リンク)"
    }
}

