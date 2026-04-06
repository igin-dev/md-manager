#!/bin/bash
# install.sh — установка md-manager в целевой проект
#
# Использование:
#   ./install.sh                        # установить в текущую директорию
#   ./install.sh /path/to/your/project  # установить в указанный проект

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"

echo "md-manager — установка"
echo "Источник: $SCRIPT_DIR"
echo "Цель:     $TARGET"
echo ""

# Проверить что целевая директория существует
if [ ! -d "$TARGET" ]; then
  echo "Ошибка: директория $TARGET не существует"
  exit 1
fi

# Создать структуру если не существует
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.claude/agents"

# Копировать slash-команды
for cmd in md-init md-audit md-sync md-optimize; do
  SRC="$SCRIPT_DIR/.claude/commands/$cmd.md"
  DST="$TARGET/.claude/commands/$cmd.md"
  if [ -f "$DST" ]; then
    echo "⚠ Пропуск: $DST уже существует (используй --force для перезаписи)"
  else
    cp "$SRC" "$DST"
    echo "✓ Установлен: .claude/commands/$cmd.md"
  fi
done

# Копировать субагенты
for agent in md-creator md-auditor md-optimizer; do
  SRC="$SCRIPT_DIR/.claude/agents/$agent.md"
  DST="$TARGET/.claude/agents/$agent.md"
  if [ -f "$DST" ]; then
    echo "⚠ Пропуск: $DST уже существует"
  else
    cp "$SRC" "$DST"
    echo "✓ Установлен: .claude/agents/$agent.md"
  fi
done

echo ""
echo "Готово. Доступные команды:"
echo "  /md-init        — создать новый CLAUDE.md"
echo "  /md-audit       — проверить существующий файл"
echo "  /md-sync        — обновить после изменений"
echo "  /md-optimize    — оптимизировать разросшийся файл"
