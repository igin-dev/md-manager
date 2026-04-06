# md-manager

Система управления CLAUDE.md и другими MD-файлами для проектов на Claude Code.

Четыре slash-команды + три специализированных субагента для полного цикла:
создание → аудит → поддержка → оптимизация.

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
./install.sh /path/to/your/project
```

Скрипт копирует `.claude/commands/` и `.claude/agents/` в целевой проект.
Существующие файлы не перезаписываются.

## Команды

| Команда | Когда использовать |
|---|---|
| `/md-init` | Новый проект, ещё нет CLAUDE.md |
| `/md-audit` | Проверить качество существующего файла |
| `/md-sync` | После изменений в проекте (новый MCP, новый стек, новый gotcha) |
| `/md-optimize` | Файл вырос >300 строк или появилось дублирование |

## Аргументы

```bash
/md-init                              # CLAUDE.md в текущей директории
/md-init architecture                 # создать ARCHITECTURE.md
/md-init subproject hub/tools/new     # CLAUDE.md для субпроекта

/md-audit                             # все MD-файлы проекта
/md-audit hub/CLAUDE.md               # конкретный файл

/md-sync                              # описать изменения в диалоге
/md-sync добавил MCP-сервер X         # описание сразу

/md-optimize                          # все файлы
/md-optimize hub/tools/telegram-analyzer/CLAUDE.md
```

## Структура репозитория

```
md-manager/
  .claude/
    commands/         # slash-команды (точки входа)
      md-init.md
      md-audit.md
      md-sync.md
      md-optimize.md
    agents/           # субагенты (специализированная логика)
      md-creator.md   # создаёт новые файлы
      md-auditor.md   # проверяет по чеклисту
      md-optimizer.md # оптимизирует разросшиеся файлы
  templates/          # шаблоны для новых файлов
    claude-md-template.md
    architecture-md-template.md
  install.sh          # установка (Linux/macOS)
  install.ps1         # установка (Windows)
```

## Принципы

- Агент **никогда не записывает файлы без явного подтверждения**
- Аудит запускается изолированным субагентом — без влияния контекста сессии
- Поддерживается иерархия монорепо (корень → субпроект → инструмент)
- Оптимизация предлагает план перед выполнением
