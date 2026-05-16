# Протокол разработки расширения 1C BSL для Zed

## Версия: 0.1.2 (текущая)

### v0.1.2: Расширенная подсветка — конструкторы, свойства, локальные Перем, встроенные функции (2025-01-20)

**Проблема:** После анализа грамматики tree-sitter-bsl (`grammar.js` с master-ветки) и сравнения с эталонным `vsc-language-1c-bsl` (43KB tmLanguage) обнаружены пробелы:
1. Тип после `Новый` не подсвечивался (например, `Новый Структура`)
2. Свойства объектов (`.Свойство`) и индексы (`[0]`) не отличались от обычных переменных
3. Локальный `Перем` внутри тела процедур (`var_statement`) не подсвечивался
4. ~120 встроенных функций из эталона отсутствовали

**Исправления:**

| # | Что | Правило | Scope |
|---|-----|---------|-------|
| 1 | Тип после `Новый` | `new_expression type: (identifier) @type` | `@type` |
| 2 | Тип в `Новый(...)` | `new_expression_method type: (expression) @type` | `@type` |
| 3 | Свойства `.Свойство` | `(property) @variable.member` | `@variable.member` |
| 4 | Локальный Перем | `var_statement var_name: (identifier) @variable` | `@variable` |
| 5 | +14 категорий встроенных функций | ~120 новых идентификаторов | `@function.builtin`, `@variable.builtin` |

**Новые категории встроенных функций:**
- Конфигурация (ПолучитьОбщийМакет, ПредопределенноеЗначение, ...)
- Сеанс работы (заголовки, пользователи, языки)
- ОС и внешние компоненты (КомандаСистемы, ЗапуститьПриложение, ПолучитьCOMОбъект, ...)
- Временное хранилище (ПоместитьВоВременноеХранилище, ...)
- Работа с данными ИБ (НайтиПомеченныеНаУдаление, ...)
- Журнал регистрации (ЗаписьЖурналаРегистрации, ...)
- Навигационные ссылки и окна
- События приложения (ПередНачаломРаботыСистемы, ...)
- Двоичные данные
- Время (универсальное/местное)
- Функциональные опции
- Сериализация значений (ЗначениеВСтрокуВнутр, ЗначениеВДанныеФормы, ...)
- Расширенные глобальные переменные (ХранилищеВариантовОтчетов, БиблиотекаСтилей, ...)

**Документирование scope'ов:** Добавлена таблица всех scope'ов Zed в заголовок `highlights.scm`.

**Изменённые файлы:**
- `languages/bsl/highlights.scm` — версия 0.1.1 → 0.1.2, +70 строк

**Hotfix:** `new_expression_method type:` исправлен с `(identifier)` на `(expression)` — в грамматике ca710eb поле `type` ожидает `expression`, несовпадение типа поля вызывало полный отказ компиляции query-файла (подсветка пропадала целиком).

**Итого покрытие:** ~220 встроенных функций + ~50 глобальных переменных/свойств.

---

## Версия: 0.1.1

### v0.1.1: Исправление подсветки параметров и Экспорт (2025-01-20)

**Проблема:** Параметры процедур/функций и `Экспорт` не подсвечивались.

**Корневая причина:**
1. `parameter` — именованный узел внутри `parameters`, но Tree-sitter queries должны его видеть.
   Добавлены как общий захват `(parameter name: ...)`, так и явные захваты внутри
   `procedure_definition` и `function_definition` для надёжности.
2. `EXPORT_KEYWORD` используется как `field('export', ...)` в грамматике, поэтому добавлены
   полевые захваты: `procedure_definition export: (EXPORT_KEYWORD)`, `function_definition export: ...`,
   `var_definition export: ...`, `variable_spec export: ...`.
3. Добавлена подсветка `Знач` в параметрах: `(parameter val: (VAL_KEYWORD) @storage.modifier)`.
4. Добавлена подсветка значений по умолчанию параметров: `(parameter def: (_) @constant)`.

**Изменённые файлы:**
- `languages/bsl/highlights.scm` — версия 0.1.0 → 0.1.1, +30 строк полевых захватов

**Изучены стандарты:**
- `its.1c.ru/db/v8std#content:437:hdoc` — Оформление текстов запросов
- `its.1c.ru/db/v8std/content/456/hdoc` — Тексты модулей
- `github.com/kuzyara/CodeStyle1C` — community code style guide (~20 правил)
- `github.com/AllexAllex/standart` — корпоративные стандарты разработки (~83 правила)

**Вывод по стандартам:** Большинство из них проверяются bsl-language-server (LSP), а не грамматикой.
Грамматика должна обеспечивать базовую подсветку; LSP — диагностику и автофиксы.

---

## Версия: 0.1.0 (предрелиз)

### v0.1.0: Релизная подготовка (2025-01-20)

**Выполнено:**
- README.md — переведён на английский, обновлён под v0.1.0
- CHANGELOG.md — создан (0.0.1 → 0.1.0)
- Версия поднята: extension.toml (0.0.3→0.1.0), Cargo.toml (0.0.3→0.1.0)
- WASM артефакт скопирован в корень: 1c-bsl.wasm (158K)

### v0.1.0: Rust WASM-расширение (2025-01-20)

**Созданы файлы:**
- `Cargo.toml` — манифест Rust-проекта (target: wasm32-wasip1, crate: cdylib)
- `src/lib.rs` — реализация trait `Extension`: `find_java()`, `ensure_jar()`, `language_server_command()`
- `extension.toml` — добавлен `wasm = true` для авто-запуска LSP через WASM
- `1c-bsl.wasm` — скомпилированный WASM (158K, release, LTO)
- `docs/WASM_BUILD.md` — инструкция по сборке (EN)
- `docs/LSP_SETUP.md` — переведён на английский

**Сборка:** `cargo build --target wasm32-wasip1 --release` — успешно.

**Архитектура:**
- `find_java()`: сначала проверяет `JAVA_HOME` (оба варианта: java/java.exe), fallback — "java"
- `ensure_jar()`: кэширует JAR в `~/.cache/zed/bsl-language-server/`; скачивает через `latest_github_release()` + `download_file()` из `1c-syntax/bsl-language-server`
- `language_server_command()`: возвращает `Command { program: java, args: ["-Xmx2g", "-jar", jar] }`
- Статус-индикатор в UI через `set_language_server_installation_status()`

### v0.0.3 bugfix 2: Улучшен injections.scm (2025-01-20)

**Изменения:**
- Regex упрощён: `(?i)` для регистронезависимости, 4 альтернативы вместо 8
- Добавлен подробный комментарий, объясняющий `[\\s|]*` (pipe = символ конкатенации строк BSL, не альтернация)
- Документированы поддерживаемые типы запросов (ВЫБРАТЬ/SELECT → query, УНИЧТОЖИТЬ/DROP → destroy_statement)

### v0.0.3 bugfix 1: Исправлена критическая ошибка подсветки (2025-01-20)

**Проблема:** Подсветка синтаксиса не работала вообще.

**Корневая причина:** В `languages/bsl/highlights.scm` использовался скрытый узел `_var_definition_variables`. Узлы Tree-sitter, начинающиеся с `_`, не экспортируются в CST и отсутствуют в `node-types.json`. Когда Zed пытался скомпилировать query-файл с несуществующим узлом, компиляция падала, и подсветка отключалась полностью.

**Исправление:** Убрана прямая ссылка на `_var_definition_variables` в запросе `var_definition`. Вместо этого `variable_spec` запрашивается напрямую внутри `var_definition`.

**Другие проверки:**
- Все остальные имена узлов в `highlights.scm`, `indents.scm`, `outline.scm`, `textobjects.scm` валидны и присутствуют в `node-types.json`.
- Других скрытых узлов (`_*`) в запросах `.scm` не обнаружено.
- WASM-грамматики собраны tree-sitter v0.25.10 (LANGUAGE_VERSION 15), валидны.

### v0.0.3: Публикация в каталог Zed (2025-01-20)

- ✅ Форкнут `zed-industries/extensions` → `Nesterland/extensions`
- ✅ Добавлен submodule `extensions/1c-bsl` → https://github.com/Nesterland/zed-1c-bsl
- ✅ Прописана запись в `extensions.toml` (алфавитный порядок)
- ✅ Открыт PR в zed-industries/extensions
- ⬜ Ожидание ревью и мёрджа

---

## Этап 1: Анализ и улучшение подсветки синтаксиса (2025-01-20)

### Источники для анализа

- `https://github.com/1c-syntax/bsl-language-server` — основной Language Server Protocol сервер для BSL и OneScript.
- `https://github.com/1c-syntax/vsc-language-1c-bsl` — VS Code расширение с эталонной подсветкой (43KB tmLanguage).
- `https://github.com/alkoleft/tree-sitter-bsl` — Tree-sitter грамматика BSL/SDBL.
- `https://github.com/Nesterland/zed-1c-bsl` — наш репозиторий.

### Проблемы текущей версии (0.0.1)

1. **Слишком тусклая подсветка** — почти все ключевые слова помечены как `@keyword` (один цвет).
2. **Не весь код подсвечивается** — отсутствуют:
   - Встроенные функции глобального контекста (`Сообщить`, `ТипЗнч`, `СтрДлина`...)
   - Разделение модификаторов (`Экспорт`, `Знач`) от ключевых слов
   - Параметры процедур/функций
   - Объявления переменных (`Перем`)
   - Метки (`~метка:`)
   - Константы `Истина`/`Ложь`/`Неопределено`/`NULL`
   - Встроенные функции SDBL (`Сумма`, `Количество`...)

### План доработок

#### Фаза 1: Детализация scope'ов подсветки
- [x] 1.1 BSL: Разделить `@keyword` на `@keyword.control`, `@keyword.operator`, `@storage.modifier`, `@keyword.directive`
- [x] 1.2 BSL: Добавить `@constant.builtin` (Истина, Ложь, Неопределено, NULL)
- [x] 1.3 BSL: Добавить `@variable` (Перем), `@variable.parameter` (параметры), `@label` (метки)
- [x] 1.4 BSL: Добавить `@function.builtin` для встроенных функций глобального контекста
- [x] 1.5 BSL: Добавить `@namespace` для областей препроцессора
- [x] 1.6 SDBL: Детализировать scope'ы аналогично BSL
- [x] 1.7 SDBL Embedded: Синхронизировать с SDBL

#### Фаза 2: Сниппеты
- [x] 2.1 Расширить набор сниппетов из vsc-language-1c-bsl (71KB → адаптировать для Zed)

#### Фаза 3: Новые возможности
- [x] 3.1 Добавить `indents.scm` для авто-отступов (v0.0.3: +Иначе/ИначеЕсли, +скобки, имена узлов сверены с grammar.js)
- [x] 3.2 Интеграция `bsl-language-server` (LSP) — декларация в extension.toml + config.toml, документация docs/LSP_SETUP.md, шаблон .bsl-language-server.json

---

## История изменений

### v0.0.3 (текущая)
- Обновлён `indents.scm` до v0.0.3: добавлены отступы для `Иначе`/`ИначеЕсли` (`else_clause`/`elseif_clause`), отступ для многострочных выражений в скобках (`parenthesized_expression`)
- Имена узлов Tree-sitter в `indents.scm` сверены с `grammar.js` и `node-types.json` (rev 5152121) — все совпадают
- Добавлен `[language_servers.bsl]` в `extension.toml` — декларация BSL Language Server
- Обновлён `languages/bsl/config.toml` — связан язык BSL с LSP-сервером (`language_servers = ["bsl"]`)
- Создан `docs/LSP_SETUP.md` — пошаговая инструкция по настройке LSP
- Обновлён `README.md` — добавлен раздел LSP-диагностика и автодополнение
- Создан `.bsl-language-server.json` — шаблон конфигурации BSL Language Server
- Созданы `PLAN.md`, `TZ.md` — план разработки и техническое задание
- Оптимизированы `.cursorrules` и `AGENTS.md` — экономия контекстного окна
- В плане: проверка в реальном Zed (indents.scm, LSP-диагностика)

### v0.0.2
- Создан `languages/bsl/indents.scm` — авто-отступы v0.0.2 (процедуры, функции, условия, циклы, исключения, препроцессор)
- Созданы `.cursorrules`, `AGENTS.md` — контекст для AI-ассистентов
- Детализированы scope'ы BSL/SDBL подсветки (Фаза 1 завершена)
- Расширены сниппеты до 40 штук (Фаза 2 завершена)

### v0.0.1 (базовая)
- Поддержка `.bsl`, `.osl`, `.sdbl`
- Tree-sitter подсветка BSL/SDBL
- Инъекция SDBL в строки BSL
- Сниппеты
- Outline, text objects
