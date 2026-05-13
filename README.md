# 1C BSL для Zed

Расширение для IDE Zed с поддержкой подсветки синтаксиса 1C:Enterprise BSL, OneScript и языка запросов 1С SDBL.

Репозиторий проекта: `https://github.com/Nesterland/zed-1c-bsl`.

## Что поддерживается

- Файлы BSL: `.bsl`, `.osl`.
- Файлы запросов 1С: `.sdbl`.
- Подсветка ключевых слов, процедур, функций, вызовов методов, строк, чисел, дат, комментариев и препроцессора.
- Подсветка встроенных запросов 1С внутри строк BSL, если строка начинается с `ВЫБРАТЬ`, `SELECT`, `УНИЧТОЖИТЬ` или `DROP`.
- Скобки и парные символы.
- Сниппеты для процедур, функций, условий, циклов, попыток и областей.

## Структура

- `extension.toml` — манифест расширения Zed.
- `languages/bsl/config.toml` — описание языка BSL.
- `languages/bsl/highlights.scm` — правила подсветки BSL.
- `languages/bsl/injections.scm` — внедрение подсветки SDBL в строки BSL.
- `languages/sdbl/config.toml` — описание языка SDBL.
- `languages/sdbl/highlights.scm` — правила подсветки SDBL.
- `languages/sdbl-embedded/config.toml` — описание встроенного языка запросов.
- `languages/sdbl-embedded/highlights.scm` — правила подсветки встроенного SDBL.
- `snippets/bsl.json` — сниппеты.
- `examples/basic.bsl` — пример BSL-файла.
- `examples/query.sdbl` — пример файла запроса.

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
