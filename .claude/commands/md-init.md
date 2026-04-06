---
description: Создаёт новый CLAUDE.md или другой MD-файл (architecture, conventions) для проекта. Use when the user asks to create, generate, or initialize a CLAUDE.md, ARCHITECTURE.md, or CONVENTIONS.md for a new project or subproject.
argument-hint: "[claude|architecture|conventions|subproject <path>]"
allowed-tools: Read, Glob, Write, Agent
---

# /md-init

Создаёт MD-файл для нового проекта или субпроекта монорепо.

## Использование

```
/md-init                              # CLAUDE.md в текущей директории
/md-init architecture                 # создать ARCHITECTURE.md
/md-init conventions                  # создать CONVENTIONS.md
/md-init subproject hub/tools/new     # CLAUDE.md для субпроекта монорепо
```

## Выполнение

**Шаг 1 — определить тип и цель.**

Разбери `$ARGUMENTS`:
- Пусто → `CLAUDE.md` в текущей директории
- `architecture` → `ARCHITECTURE.md`
- `conventions` → `CONVENTIONS.md`
- `subproject <path>` → `CLAUDE.md` в указанном пути

Определи контекст: есть ли родительский `CLAUDE.md`? Если да — субпроект, нужна только дельта.

**Шаг 2 — собрать контекст проекта.**

Прочитай через Read то что существует (пропускай несуществующие):
- `requirements.txt` / `pyproject.toml` / `package.json` — стек
- `.mcp.json`, `.claude/settings.json` — MCP и настройки
- `README.md` — описание проекта
- Родительский `CLAUDE.md` — если субпроект

Получи структуру директорий через Glob `**/*` (глубина 2 уровня).

**Шаг 3 — оценить объём и предложить разбивку.**

Если контента набирается >250 строк — предложи разбить:
- Критичные инструкции, gotchas, запреты → `CLAUDE.md`
- Архитектура → `ARCHITECTURE.md`
- Стиль кода, конвенции → `CONVENTIONS.md`

Спроси подтверждение перед созданием нескольких файлов.

**Шаг 4 — вызови субагент `md-creator`.**

Используй Agent tool.
Передай в prompt:

```
Создай MD-файл для проекта.

Тип файла: {claude-md | architecture-md | conventions-md}
Тип проекта: {root | subproject | standalone}

Рабочая директория (корень проекта): {текущий путь}

=== СТЕК ===
{содержимое requirements.txt / package.json / pyproject.toml или "не найдено"}

=== MCP-СЕРВЕРЫ (.mcp.json) ===
{содержимое или "не настроены"}

=== README ===
{содержимое или "отсутствует"}

=== СТРУКТУРА ДИРЕКТОРИЙ ===
{список файлов 2 уровня из Glob}

=== РОДИТЕЛЬСКИЙ CLAUDE.MD ===
{содержимое или "отсутствует — создаём корневой файл"}
```

**Шаг 5 — показать черновик и запросить подтверждение.**

Выведи черновик. Спроси: "Записать как `{имя файла}`?"
Не пиши файл без явного "да".

$ARGUMENTS
