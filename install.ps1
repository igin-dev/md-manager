# install.ps1 — установка md-manager в целевой проект (Windows)
#
# Использование:
#   .\install.ps1 C:\path\to\your\project
#   .\install.ps1 C:\path\to\your\project --force   # перезаписать существующие

param(
    [Parameter(Position=0)]
    [string]$Target,
    [switch]$Force = $false
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $Target) { $Target = (Get-Location).Path }

# Нормализуем путь для корректного сравнения (case-insensitive)
$resolved = Resolve-Path $Target -ErrorAction SilentlyContinue
if (-not $resolved) {
    Write-Error "Директория $Target не существует"
    exit 1
}
$Target = $resolved.Path

Write-Host "md-manager — установка"
Write-Host "Источник: $ScriptDir"
Write-Host "Цель:     $Target"
if ($Force) { Write-Host "Режим:    --force (перезапись существующих файлов)" }
Write-Host ""

$script:installed = 0
$script:skipped = 0

function Install-File {
    param([string]$Src, [string]$Dst)
    if (-not (Test-Path $Src)) {
        return
    }
    $dir = Split-Path -Parent $Dst
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $rel = $Dst.Substring($Target.Length).TrimStart("\")
    if ((Test-Path $Dst) -and -not $Force) {
        Write-Host "  Пропуск: $rel (уже существует, используй --force)"
        $script:skipped++
    } else {
        Copy-Item $Src $Dst -Force
        Write-Host "  Установлен: $rel"
        $script:installed++
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
Write-Host "Установлено: $($script:installed) файлов. Пропущено: $($script:skipped)."
if ($script:installed -eq 0 -and $script:skipped -gt 0) {
    Write-Host "Все файлы уже существуют. Используй --force для перезаписи."
}
Write-Host ""
Write-Host "Доступные команды в Claude Code:"
Write-Host "  /md-init      — создать новый CLAUDE.md или другой MD-файл"
Write-Host "  /md-audit     — проверить файл по чеклисту качества"
Write-Host "  /md-fix       — исправить проблемы найденные аудитом"
Write-Host "  /md-sync      — обновить после изменений в проекте"
Write-Host "  /md-optimize  — оптимизировать разросшийся файл"
