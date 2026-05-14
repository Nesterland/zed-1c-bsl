# 1C BSL для Zed

Расширение для IDE Zed с поддержкой подсветки синтаксиса 1C:Enterprise BSL, OneScript и языка запросов 1С SDBL.

Репозиторий проекта: https://github.com/Nesterland/zed-1c-bsl

**Версия:** 0.0.3 | **Статус:** 🚧 В разработке

## Что поддерживается

- Файлы BSL: `.bsl`, `.osl`.
- Файлы запросов 1С: `.sdbl`.
- Подсветка ключевых слов, процедур, функций, вызовов методов, строк, чисел, дат, комментариев и препроцессора.
- Подсветка встроенных запросов 1С внутри строк BSL, если строка начинается с `ВЫБРАТЬ`, `SELECT`, `УНИЧТОЖИТЬ` или `DROP`.
- Скобки и парные символы.
- Сниппеты для процедур, функций, условий, циклов, попыток и областей (~40 шт).
- Outline (структура документа), text objects.
- LSP-диагностика и автодополнение через [BSL Language Server](https://github.com/1c-syntax/bsl-language-server).
- Авто-отступы (indents) для всех основных конструкций.

## Структура

```
zed-1c-bsl/
  extension.toml              # Манифест расширения + LSP-декларация
  LICENSE                     # MIT
  README.md
  languages/
    bsl/
      config.toml             # Описание языка BSL
      highlights.scm          # Правила подсветки BSL
      injections.scm          # Внедрение SDBL в строки BSL
      brackets.scm            # Парные скобки
      indents.scm             # Авто-отступы
      outline.scm             # Структура документа
      textobjects.scm         # Text objects
    sdbl/
      config.toml
      highlights.scm
    sdbl-embedded/
      config.toml
      highlights.scm
  snippets/
    bsl.json                  # ~40 сниппетов
  examples/
    basic.bsl                 # Пример BSL-файла
    query.sdbl                # Пример файла запроса
  docs/
    LSP_SETUP.md              # Инструкция по настройке LSP
  .bsl-language-server.json   # Шаблон конфигурации LSP
  grammars/                   # Tree-sitter грамматики (submodule)
```

## LSP-диагностика и автодополнение

Расширение поддерживает интеграцию с **BSL Language Server** (LSP) — диагностика ошибок, автодополнение, навигация, hover, переименование и многое другое.

Для настройки потребуется Java и JAR-файл `bsl-language-server.jar`. Подробная инструкция — в [docs/LSP_SETUP.md](docs/LSP_SETUP.md).

> В будущем (Фаза 4) расширение будет само находить Java и скачивать сервер без ручной настройки.

## Как установить локально в Zed

1. Установи Rust через `rustup`, если он ещё не установлен. Zed использует Rust для сборки Tree-sitter грамматик dev-расширений.
2. Открой Zed.
3. Открой Extensions.
4. Нажми `Install Dev Extension`.
5. Выбери папку этого проекта: `BSL`.
6. Открой `examples/basic.bsl` или любой `.bsl` файл.

Если расширение не загрузилось, открой лог Zed через команду `zed: open log` и проверь ошибки сборки grammar.

## Используемая грамматика

Расширение использует Tree-sitter грамматику:

- `https://github.com/alkoleft/tree-sitter-bsl`

В `extension.toml` зафиксирован конкретный `rev`, чтобы сборка была повторяемой.

## Публикация

План публикации расширения:

1. Создать публичный репозиторий `https://github.com/Nesterland/zed-1c-bsl`.
2. Загрузить туда содержимое этой папки.
3. Проверить расширение локально через `Install Dev Extension` в Zed.
4. Сделать fork репозитория `https://github.com/zed-industries/extensions`.
5. Добавить расширение в официальный реестр Zed extensions.
6. Открыть Pull Request в `zed-industries/extensions`.

## Лицензия

MIT. См. файл `LICENSE`.
