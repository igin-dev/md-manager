# Conventions — [Название проекта]

## Код

[Стиль, паттерны — только то что отклоняется от стандартных конвенций языка]

```python
# Правильно
[пример]

# Неправильно
[пример]
```

## Именование

| Что | Паттерн | Пример |
|---|---|---|
| Файлы | [snake_case / kebab-case] | `market_data.py` |
| Классы | [PascalCase] | `MarketContext` |
| Функции | [snake_case] | `fetch_candles()` |
| Константы | [UPPER_SNAKE] | `MAX_RETRIES = 3` |

## Обработка ошибок

```python
# Стандартный паттерн для этого проекта
try:
    [операция]
except [ExceptionType] as e:
    logger.error("[контекст]: %s", e, exc_info=True)
    [что делать дальше]
```

## Логирование

```python
import logging
from logging.handlers import RotatingFileHandler

# Настройка (стандартная для проекта)
handler = RotatingFileHandler("logs/app.log", maxBytes=5*1024*1024, backupCount=5)
handler.setFormatter(logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s"))
```

- Уровни: DEBUG (детали), INFO (события), WARNING (аномалии), ERROR (ошибки)
- Запрещено: `print()` — только `logger.*`

## Тестирование

```bash
# Запуск тестов
[команда]
```

- Тесты в: `[путь/к/tests/]`
- Что покрывать: [критерии]
- Что не покрывать: [исключения]
