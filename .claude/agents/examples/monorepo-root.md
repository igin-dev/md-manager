# Пример: CLAUDE.md для монорепо (корневой файл)

Источник: реальный проект, C:/claude/CLAUDE.md
Тип: root
Размер: ~30 строк — компактный, только неочевидное

## Что здесь хорошо

- Карта субпроектов с явными путями к CLAUDE.md — агент не угадает что их нужно читать
- Autostart через Task Scheduler — это вообще нигде в коде не видно
- MCP-серверы — агент не знает о них без явного указания
- Один запрет с причиной — `print()` запрещён, потому что проект использует logging

## Чего намеренно НЕТ

- Формата логов (`%(asctime)s...`) — он виден в коде каждого модуля
- Настроек RotatingFileHandler — то же самое, читается из кода
- Паттерна try/except — стандартный Python, агент знает
- "Полного описания стека" — он разный для каждого субпроекта, там и описан

## Ключевой принцип примера

Корневой CLAUDE.md монорепо — это навигационный файл, не документация.
Его задача: дать агенту карту и предупредить о неочевидном.

---

```markdown
# C:/claude/ — монорепо

Единый git-репозиторий. Коммит глобально из корня.

## Субпроекты

| Директория | Описание | Читать перед изменением |
|---|---|---|
| `hub/` | Flask dashboard :5000 | `hub/CLAUDE.md` |
| `hub/tools/telegram-analyzer/` | Telegram news analyzer | `hub/tools/telegram-analyzer/CLAUDE.md` |
| `hub/tools/voice-input/` | Whisper voice input | `hub/tools/voice-input/CLAUDE.md` |
| `TradingAgents/` | Multi-agent trading research | нет |

## Автозапуск (Task Scheduler)

`HubServer` запускает `hub/start_hub.pyw` при старте Windows.
`VoiceInput` запускает `hub/tools/voice-input/voice_input.py`.
Перед ручным запуском проверь что процесс не активен.

## MCP-серверы (.mcp.json)

- `sqlite-hub` — SQLite БД Hub (`hub/instance/hub.db`)
- `sqlite-telegram` — SQLite БД Telegram Analyzer

## Запреты

`print()` запрещён — только `logging`. Причина: все компоненты логируют в файлы,
print пропадает при запуске через pythonw.
```
