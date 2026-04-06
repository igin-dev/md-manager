# Пример: CLAUDE.md с большим количеством gotchas (voice-input)

Источник: реальный проект, hub/tools/voice-input/CLAUDE.md
Тип: tool
Размер: 4.5 KB — на грани, но оправдан сложностью платформенных особенностей

## Что здесь хорошо

- Gotchas написаны по схеме: что запрещено → почему → что пробовали и не сработало
- Перечислены альтернативы которые не работают — предотвращает "а давай попробуем X"
- Описание потоков состояний — ASCII-диаграмма лучше 10 строк прозы
- Секция про вставку текста — нетривиальное поведение по типу окна
- Обоснование нестандартного решения (_log() вместо logging)

## Что можно улучшить

- Секцию "AI-режим" можно было сжать таблицей (3 хоткея → таблица)
- Секцию "Конфигурация" можно вынести в @CONVENTIONS.md

---

```markdown
# Voice Input — голосовой ввод

Десктопный голосовой ввод через Whisper + опциональный AI (Gemini). Один файл: `voice_input.py`.

## Запуск

| Сценарий | Команда |
|---|---|
| Через Hub (рекомендуется) | Кнопка "Запустить" на дашборде |
| Вручную с консолью | `python voice_input.py` |
| Без консоли (как Hub) | `pythonw voice_input.py` → лог в `voice_input.log` |

## Запреты

**`suppress=True` в keyboard.add_hotkey — ЗАПРЕЩЕНО.**
Устанавливает глобальный WH_KEYBOARD_LL хук → блокирует Ctrl и Alt во всех приложениях.

Альтернативы которые не работают:
- `RegisterHotKey` Win32 API — конфликтует с ShareX (ошибка 1409)
- Кастомный WH_KEYBOARD_LL через ctypes — ошибка в callback блокирует клавиатуру до перезагрузки
- `trigger_on_release=True` — ломает регистрацию хоткеев с модификаторами

**Вызовы tkinter из не-главного потока — ЗАПРЕЩЕНО.**
Только через `overlay_root.after(0, fn)`. Прямой вызов → краш без исключения.

## Потоки и состояния

```
idle (recording=False, busy=False)
  → [hotkey] → start_recording() → recording=True
  → [hotkey] → stop_recording() → busy=True → do_transcribe()
    → (AI/translate) → type_text(final_text) → busy=False → idle
```

Если `busy=True` — повторный хоткей игнорируется.

## Вставка текста

Три метода по типу активного окна:
- Терминалы (ConsoleWindowClass, mintty, PuTTY) → `SendInput` Unicode
- IDE (cursor.exe, code.exe) → Shift+Insert из буфера
- GUI → Ctrl+V

Shift+Insert для IDE: Ctrl+V не работает в терминале Cursor; SendInput теряет пробелы в Electron.

## Логирование

`_log()` вместо стандартного `logging` — намеренно: одна функция пишет в print() и файл.
Truncate при >1 МБ (не rotation). Не рефакторить на стандартный logging.
```
