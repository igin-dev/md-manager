# Пример: CLAUDE.md для монорепо (корневой файл)

Источник: реальный проект, C:/claude/CLAUDE.md (улучшенная версия)
Тип: root
Размер: ~60 строк — компактный, навигационный

## Что здесь хорошо

- Карта субпроектов с ссылками на их CLAUDE.md
- Глобальные coding standards которые не повторяются в дочерних
- MCP-серверы верхнего уровня
- Autostart-задачи — агент знает что уже запущено

## Чего намеренно нет

- Деталей каждого субпроекта — они в их собственных CLAUDE.md
- Полного описания стека — он разный для разных инструментов

---

```markdown
# C:/claude/ — монорепо

Единый git-репозиторий. Коммит глобально из корня.

## Структура

| Директория | Описание | CLAUDE.md |
|---|---|---|
| `hub/` | Flask dashboard :5000 | `hub/CLAUDE.md` |
| `hub/tools/telegram-analyzer/` | Telegram news analyzer | `hub/tools/telegram-analyzer/CLAUDE.md` |
| `hub/tools/voice-input/` | Whisper голосовой ввод | `hub/tools/voice-input/CLAUDE.md` |
| `hub/tools/backtest-chart/` | Backtest visualizer | нет |
| `TradingAgents/` | Multi-agent trading research | нет |

## Autostart (Task Scheduler)

| Задача | Запускает |
|---|---|
| `HubServer` | `hub/start_hub.pyw` |
| `VoiceInput` | `hub/tools/voice-input/voice_input.py` |

## Глобальные стандарты кода

- Комментарии в коде — на русском
- Логирование: `RotatingFileHandler(maxBytes=5MB, backupCount=5)` в `./logs/`
- Формат: `%(asctime)s - %(name)s - %(levelname)s - %(message)s`
- Исключения: `try/except` + `logger.error("...", exc_info=True)`
- Запрещено: `print()` вместо `logging`

## MCP-серверы (.mcp.json)

- `playwright` — браузерная автоматизация и скрейпинг
- `context7` — документация библиотек (настроен глобально, не дублировать в субпроектах)
```
