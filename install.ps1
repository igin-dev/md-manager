# install.ps1 — установка md-manager в целевой проект (Windows)
#
# Использование:
#   .\install.ps1                         # установить в текущую директорию
#   .\install.ps1 C:\path\to\your\project # установить в указанный проект

param(
    [string]$Target = (Get-Location).Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "md-manager — установка"
Write-Host "Источник: $ScriptDir"
Write-Host "Цель:     $Target"
Write-Host ""

if (-not (Test-Path $Target)) {
    Write-Error "Директория $Target не существует"
    exit 1
}

# Создать структуру
New-Item -ItemType Directory -Force -Path "$Target\.claude\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\.claude\agents" | Out-Null

# Копировать slash-команды
$commands = @("md-init", "md-audit", "md-sync", "md-optimize")
foreach ($cmd in $commands) {
    $src = "$ScriptDir\.claude\commands\$cmd.md"
    $dst = "$Target\.claude\commands\$cmd.md"
    if (Test-Path $dst) {
        Write-Host "  Пропуск: .claude\commands\$cmd.md (уже существует)"
    } else {
        Copy-Item $src $dst
        Write-Host "  Установлен: .claude\commands\$cmd.md"
    }
}

# Копировать субагенты
$agents = @("md-creator", "md-auditor", "md-optimizer")
foreach ($agent in $agents) {
    $src = "$ScriptDir\.claude\agents\$agent.md"
    $dst = "$Target\.claude\agents\$agent.md"
    if (Test-Path $dst) {
        Write-Host "  Пропуск: .claude\agents\$agent.md (уже существует)"
    } else {
        Copy-Item $src $dst
        Write-Host "  Установлен: .claude\agents\$agent.md"
    }
}

Write-Host ""
Write-Host "Готово. Доступные команды в Claude Code:"
Write-Host "  /md-init        — создать новый CLAUDE.md"
Write-Host "  /md-audit       — проверить существующий файл"
Write-Host "  /md-sync        — обновить после изменений"
Write-Host "  /md-optimize    — оптимизировать разросшийся файл"
