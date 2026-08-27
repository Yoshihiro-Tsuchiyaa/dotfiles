# CheckLink.ps1

$destRoot  = "C:\Tools\bin"
$wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"

# NameMap 読み込み
. "$PSScriptRoot\NameMap.ps1"

# Write-Host "=== CheckLink.ps1 ==="

$countHardlink_WinGet = 0

foreach ($file in Get-ChildItem $destRoot -Filter *.exe) {

    $item = Get-Item $file.FullName
    $shortName = $file.Name

    #
    # 読み替え（Winget 側で探す名前）
    #
    if ($NameMap.ContainsKey($shortName)) {
        $searchName = $NameMap[$shortName]
    } else {
        $searchName = $shortName
    }

    #
    # 1. ハードリンクの名前リスト取得
    #
    $rawLinks = fsutil hardlink list $file.FullName 2>$null
    $rawLinks = $rawLinks | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

    #
    # 2. ハードリンクの名前リストに Winget Packages が含まれているか
    #
    if ($rawLinks -match "\\Microsoft\\WinGet\\Packages\\") {
        Write-Host "[Hardlink/WinGet] $shortName"
        $countHardlink_WinGet++
        continue
    }

    #
    # 3. Winget Packages 内に searchName が存在するか（読み替え適用）
    #
    $found = Get-ChildItem $wingetRoot -Recurse -Filter $searchName -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($found) {
        Write-Host "[STALE] $shortName"
        continue
    } else {
        Write-Host "[FILE] $shortName"
    }

}

Write-Host "countHardlink_WinGet = $countHardlink_WinGet"
