# install.ps1 — установка md-manager в целевой проект (Windows)
#
# Использование:
#   .\install.ps1 C:\path\to\your\project
#   .\install.ps1 C:\path\to\your\project --force   # перезаписать существующие

param(
    [string]$Target = (Get-Location).Path,
    [switch]$Force = $false
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "md-manager — установка"
Write-Host "Источник: $ScriptDir"
Write-Host "Цель:     $Target"
if ($Force) { Write-Host "Режим:    --force (перезапись существующих файлов)" }
Write-Host ""

if (-not (Test-Path $Target)) {
    Write-Error "Директория $Target не существует"
    exit 1
}

function Install-File {
    param([string]$Src, [string]$Dst)
    if (-not (Test-Path $Src)) {
        Write-Host "  Пропуск: $Src (источник не найден)"
        return
    }
    $dir = Split-Path -Parent $Dst
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    if ((Test-Path $Dst) -and -not $Force) {
        $rel = $Dst.Replace($Target, "").TrimStart("\")
        Write-Host "  Пропуск: $rel (уже существует, используй --force)"
    } else {
        Copy-Item $Src $Dst -Force
        $rel = $Dst.Replace($Target, "").TrimStart("\")
        Write-Host "  Установлен: $rel"
    }
}

# Slash-команды
foreach ($cmd in @("md-init", "md-audit", "md-fix", "md-sync", "md-optimize")) {
    Install-File "$ScriptDir\.claude\commands\$cmd.md" "$Target\.claude\commands\$cmd.md"
}

# Субагенты (основные файлы)
foreach ($agent in @("md-creator", "md-auditor", "md-optimizer")) {
    Install-File "$ScriptDir\.claude\agents\$agent.md" "$Target\.claude\agents\$agent.md"
}

# Rules
Get-ChildItem "$ScriptDir\.claude\agents\rules\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    Install-File $_.FullName "$Target\.claude\agents\rules\$($_.Name)"
}

# Templates
Get-ChildItem "$ScriptDir\.claude\agents\templates\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    Install-File $_.FullName "$Target\.claude\agents\templates\$($_.Name)"
}

# Examples
Get-ChildItem "$ScriptDir\.claude\agents\examples\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    Install-File $_.FullName "$Target\.claude\agents\examples\$($_.Name)"
}

Write-Host ""
Write-Host "Готово. Доступные команды в Claude Code:"
Write-Host "  /md-init      — создать новый CLAUDE.md или другой MD-файл"
Write-Host "  /md-audit     — проверить файл по чеклисту качества"
Write-Host "  /md-fix       — исправить проблемы найденные аудитом"
Write-Host "  /md-sync      — обновить после изменений в проекте"
Write-Host "  /md-optimize  — оптимизировать разросшийся файл"
