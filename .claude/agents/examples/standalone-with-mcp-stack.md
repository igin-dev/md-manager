# Пример: CLAUDE.md со стеком и MCP (backtester)

Источник: реальный проект, Cryptobacktester2/CLAUDE.md
Тип: root (standalone репо)
Размер: 4.6 KB — близко к верхней границе, но оправдан строгими правилами стека

## Что здесь хорошо

- Явные запреты на уровне библиотек с объяснением (только TA-Lib)
- Нумерованные правила кода — агент легко проверяет соответствие
- MCP-серверы с примерами конкретных инструментов и форматом символов
- Секция про skills — агент знает какие инструменты доступны
- Целевые рынки с явным указанием что НЕ поддерживается

## Что можно улучшить

- Секции "VectorBT Skills" и "Code Review Skill" можно вынести в @CONVENTIONS.md
- Секцию "Соглашения" объединить со стеком

---

```markdown
# Cryptobacktester2

Бэктестер торговых стратегий. Рынки: Crypto (primary, CCXT/Binance) + US Stocks (yfinance).
Индийский рынок не поддерживается. OpenAlgo не используется.

## MCP-серверы

### Crypto.com Exchange MCP
- `get_candlestick` — OHLCV свечи для бэктестинга
- `get_ticker` / `get_tickers` — текущие цены
- `get_book` — снэпшот ордербука
- `get_instruments` — список торговых пар
Формат символов: `BTC_USDT` (через подчёркивание, не `/`).

### Context7
Настроен глобально. Использовать для документации библиотек автоматически.

## Стек

- **Python** — основной язык
- **VectorBT** — бэктестинг
- **TA-Lib** — индикаторы (ВСЕГДА, никогда VectorBT built-in)
- **CCXT/Binance** — крипто данные
- **yfinance** — US stocks данные
- **Plotly** — визуализация (`template="plotly_dark"`)

## Правила кода

1. Индикаторы — только `talib`. Запрещено: `vbt.MA.run()`, `close.rolling().mean()`
2. Сигналы — всегда `exrem()` после `.fillna(False)`
3. Комиссии крипто: `fees=0.001, fixed_fees=0, min_size=0, size_granularity=0`
4. Комиссии US: `fees=0.0001, fixed_fees=1.0, min_size=1, size_granularity=1`
5. Бенчмарк: BTC Hold (крипто) / S&P 500 (US)
6. API ключи: только через `.env` + `python-dotenv` + `find_dotenv()`
7. Визуализация: только Plotly с `template="plotly_dark"`

## Навигация по скиллам

- `/review` — строгий code review стратегий (5 категорий, severity levels)
- `vectorbt-expert` в `.agents/skills/` — база знаний по VectorBT API
```
