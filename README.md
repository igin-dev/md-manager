# md-manager

Система управления CLAUDE.md и другими MD-файлами для проектов на Claude Code.

Пять slash-команд + три субагента для полного цикла:
создание → аудит → исправление → поддержка → оптимизация.

## Установка

```powershell
# Windows
git clone https://github.com/igin-dev/md-manager
cd md-manager
.\install.ps1 C:\path\to\your\project
```

```bash
# Linux / macOS
git clone https://github.com/igin-dev/md-manager
cd md-manager
chmod +x install.sh
./install.sh /path/to/your/project
```

Для обновления: добавь флаг `--force`.

## Команды

| Команда | Когда использовать |
|---|---|
| `/md-init` | Новый проект — нет CLAUDE.md |
| `/md-audit` | Проверить качество существующего файла |
| `/md-fix` | Исправить проблемы найденные аудитом |
| `/md-sync` | После изменений в проекте (новый MCP, стек, gotcha) |
| `/md-optimize` | Файл вырос или появилось дублирование |

## Типичный рабочий процесс

```
# Новый проект
/md-init                     → создаёт CLAUDE.md из контекста проекта

# Проверка и исправление
/md-audit hub/CLAUDE.md      → отчёт с проблемами по severity
/md-fix hub/CLAUDE.md        → исправляет найденные critical-проблемы

# После изменений в проекте
/md-sync добавил MCP X       → обновляет CLAUDE.md под новое состояние

# Файл разросся
/md-optimize CLAUDE.md       → предлагает план разбивки на referenced файлы
```

## Архитектура

**Slash-команды** (`.claude/commands/`) — точки входа. Собирают контекст, вызывают субагенты через Agent tool, запрашивают подтверждение перед записью.

**Субагенты** (`.claude/agents/`) — специализированная логика:
- `md-auditor` — чеклист встроен в промпт (source of truth для кодов аудита), model: sonnet
- `md-creator` — читает rules/ и examples/ через Read tool, model: sonnet  
- `md-optimizer` — правила встроены в промпт, model: sonnet

Субагенты не вызываются пользователем напрямую — только через Agent tool из команд.

## Структура репозитория

```
md-manager/
  CLAUDE.md                  # контекст для Claude Code при работе с этим репо
  .claude/
    commands/                # slash-команды (5 файлов)
    agents/
      md-creator.md          # создаёт новые MD-файлы
      md-auditor.md          # проверяет по чеклисту (чеклист встроен)
      md-optimizer.md        # планирует оптимизацию (критерии встроены)
      rules/                 # справочник для md-creator (8 файлов, читаются через Read)
      templates/             # шаблоны новых файлов (3 файла)
      examples/              # few-shot примеры реальных файлов (4 файла)
  install.sh                 # установка (Linux/macOS)
  install.ps1                # установка (Windows)
```

## Принципы

- Агент никогда не записывает файлы без явного подтверждения ("да")
- Субагенты изолированы — работают без контекста текущей сессии
- Поддерживается иерархия монорепо (корень → субпроект → инструмент)
- Чеклист аудита покрывает: избыточность, размер, навигацию, внешние зависимости, gotchas, качество записи
