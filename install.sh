#!/bin/bash
# install.sh — установка md-manager в целевой проект (Linux / macOS)
#
# Использование:
#   ./install.sh /path/to/your/project
#   ./install.sh /path/to/your/project --force   # перезаписать существующие

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET=""
FORCE=false

for arg in "$@"; do
    if [ "$arg" = "--force" ]; then
        FORCE=true
    elif [ -z "$TARGET" ]; then
        TARGET="$arg"
    fi
done

TARGET="${TARGET:-$(pwd)}"

echo "md-manager — установка"
echo "Источник: $SCRIPT_DIR"
echo "Цель:     $TARGET"
$FORCE && echo "Режим:    --force (перезапись существующих файлов)"
echo ""

if [ ! -d "$TARGET" ]; then
    echo "Ошибка: директория $TARGET не существует"
    exit 1
fi

install_file() {
    local src="$1"
    local dst="$2"
    if [ ! -f "$src" ]; then
        echo "  Пропуск: $src (источник не найден)"
        return
    fi
    local dir
    dir="$(dirname "$dst")"
    mkdir -p "$dir"
    if [ -f "$dst" ] && [ "$FORCE" = false ]; then
        echo "  Пропуск: ${dst#$TARGET/} (уже существует, используй --force)"
    else
        cp "$src" "$dst"
        echo "  Установлен: ${dst#$TARGET/}"
    fi
}

# Slash-команды
for cmd in md-init md-audit md-fix md-sync md-optimize; do
    install_file "$SCRIPT_DIR/.claude/commands/$cmd.md" "$TARGET/.claude/commands/$cmd.md"
done

# Субагенты
for agent in md-creator md-auditor md-optimizer; do
    install_file "$SCRIPT_DIR/.claude/agents/$agent.md" "$TARGET/.claude/agents/$agent.md"
done

# Rules
for f in "$SCRIPT_DIR/.claude/agents/rules/"*.md; do
    [ -f "$f" ] && install_file "$f" "$TARGET/.claude/agents/rules/$(basename "$f")"
done

# Templates
for f in "$SCRIPT_DIR/.claude/agents/templates/"*.md; do
    [ -f "$f" ] && install_file "$f" "$TARGET/.claude/agents/templates/$(basename "$f")"
done

# Examples
for f in "$SCRIPT_DIR/.claude/agents/examples/"*.md; do
    [ -f "$f" ] && install_file "$f" "$TARGET/.claude/agents/examples/$(basename "$f")"
done

echo ""
echo "Готово. Доступные команды в Claude Code:"
echo "  /md-init      — создать новый CLAUDE.md или другой MD-файл"
echo "  /md-audit     — проверить файл по чеклисту качества"
echo "  /md-fix       — исправить проблемы найденные аудитом"
echo "  /md-sync      — обновить после изменений в проекте"
echo "  /md-optimize  — оптимизировать разросшийся файл"
