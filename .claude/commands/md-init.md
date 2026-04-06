---
description: Создаёт новый CLAUDE.md или другой MD-файл (architecture, conventions) для проекта. Анализирует стек, структуру и MCP-конфигурацию.
allowed-tools: Read, Glob, Bash, Agent
---

# /md-init

Создаёт MD-файл для нового проекта или субпроекта монорепо.

## Использование

```
/md-init                              # CLAUDE.md в текущей директории
/md-init architecture                 # создать ARCHITECTURE.md
/md-init conventions                  # создать CONVENTIONS.md
/md-init subproject hub/tools/new     # CLAUDE.md для субпроекта
```

## Выполнение

**Шаг 1 — определить тип и цель.**
Разбери `$ARGUMENTS`:
- Пусто → создать `CLAUDE.md` в текущей директории
- `architecture` → создать `ARCHITECTURE.md`
- `conventions` → создать `CONVENTIONS.md`
- `subproject <path>` → создать `CLAUDE.md` в указанном пути

Определи тип проекта: монорепо / обычный репо / субпроект монорепо.

**Шаг 2 — собрать контекст проекта.**
Прочитай всё что существует:
- `package.json`, `pyproject.toml`, `requirements.txt` — стек
- `.mcp.json`, `.claude/settings.json` — MCP и настройки
- `README.md` — описание проекта
- Структуру директорий (2 уровня глубины)
- Родительский `CLAUDE.md` — если субпроект (создавать только дельту)

**Шаг 3 — оценить объём.**
Прикинь: сколько контента войдёт в файл?
Если >300 строк — предложи разбивку (CLAUDE.md + ARCHITECTURE.md + CONVENTIONS.md).
Спроси подтверждение перед созданием нескольких файлов.

**Шаг 4 — запустить субагент md-creator.**
Запусти Agent с `subagent_type: "general-purpose"` и промптом:

```
Ты — md-creator. Прочитай свои инструкции из .claude/agents/md-creator.md.

Создай файл типа: {claude-md | architecture-md | conventions-md}

Контекст проекта:
- Стек: {содержимое requirements.txt / package.json}
- MCP-серверы: {содержимое .mcp.json или "не настроены"}
- README: {содержимое README.md или "отсутствует"}
- Структура: {дерево директорий}

Родительский CLAUDE.md:
{содержимое или "отсутствует — это корневой проект"}
```

**Шаг 5 — показать и запросить подтверждение.**
Выведи черновик файла.
Спроси: "Записать файл?" — не записывай без явного "да".

$ARGUMENTS
