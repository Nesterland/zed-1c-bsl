# Протокол разработки расширения 1C BSL для Zed

## Версия: 0.0.3 (в разработке)

### v0.0.3 bugfix 1: Исправлена критическая ошибка подсветки (2025-01-20)

**Проблема:** Подсветка синтаксиса не работала вообще.

**Корневая причина:** В `languages/bsl/highlights.scm` использовался скрытый узел `_var_definition_variables`. Узлы Tree-sitter, начинающиеся с `_`, не экспортируются в CST и отсутствуют в `node-types.json`. Когда Zed пытался скомпилировать query-файл с несуществующим узлом, компиляция падала, и подсветка отключалась полностью.

**Исправление:** Убрана прямая ссылка на `_var_definition_variables` в запросе `var_definition`. Вместо этого `variable_spec` запрашивается напрямую внутри `var_definition`.

**Другие проверки:**
- Все остальные имена узлов в `highlights.scm`, `indents.scm`, `outline.scm`, `textobjects.scm` валидны и присутствуют в `node-types.json`.
- Других скрытых узлов (`_*`) в запросах `.scm` не обнаружено.
- WASM-грамматики собраны tree-sitter v0.25.10 (LANGUAGE_VERSION 15), валидны.

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
