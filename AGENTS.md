# 1C BSL — Контекст

## Суть проекта
Расширение для IDE **Zed** с поддержкой **1C:Enterprise BSL**, **OneScript** и **SDBL**.
Репозиторий: https://github.com/Nesterland/zed-1c-bsl
Версия: **0.1.2**

## Что уже работает
- Подсветка синтаксиса .bsl, .osl, .sdbl через Tree-sitter
- Детализированные scope-ы
- Инъекция SDBL в строки BSL
- Встроенные функции глобального контекста (~150 функций)
- Сниппеты (40 штук)
- Outline, text objects, brackets
- indents.scm — авто-отступы
- LSP-интеграция — bsl-language-server (WASM + ручная)
- Rust WASM-расширение (авто-LSP)

## OpenCode Desktop — Настройка 1С

### LSP (bsl-language-server)
Настроен в `opencode.json`. Требует Java 17+ и `.jar`:
```
%LOCALAPPDATA%\bsl-language-server\bsl-language-server.jar
```
Автоматически запускается для `.bsl` и `.osl` файлов.

### Skill
`@1c-bsl` — subagent со всеми инструментами 1С. Загружается из `.opencode/skills/1c-bsl.md`.

### Ключевые MCP-инструменты
| Область | Инструменты |
|---------|-------------|
| Анализ кода | `check_1c_code`, `review_1c_code`, `rewrite_1c_code`, `modify_1c_code` |
| Документация | `onec_help`, `search_1c_documentation`, `config_help`, `its_help`, `docsearch` |
| Метаданные | `metadatasearch`, `get_metadata_details`, `codesearch` |
| Neo4j Graph | `get_object_dossier`, `trace_impact`, `search_code`, `business_search` |
| Формы | `form-compile`, `form-edit`, `form-info`, `form-validate` |
| Расширения | `cfe-init`, `cfe-borrow`, `cfe-patch-method`, `cfe-diff` |
| Объекты | `meta-compile`, `meta-edit`, `meta-info`, `meta-validate`, `meta-remove` |
| Базы | `db-list`, `db-create`, `db-run`, `db-dump-cf`, `db-load-xml`, `db-update` |
| Веб | `web-publish`, `web-info`, `web-test` |

### Правила OpenCode
1. Использовать `@1c-bsl` для задач по 1С
2. Для проверки кода: `check_1c_code` → `review_1c_code`
3. Перед редактированием формы/объекта — прочитать структуру через `*-info`
4. Запросы к API строго последовательные (без `gather`/`Promise.all`)
5. Бэкап перед обновлением баз в `\\sqlbackup\Обновления`

## Ключевые файлы
| Файл | Назначение |
|------|-----------|
| extension.toml | Манифест + LSP для Zed |
| languages/bsl/*.scm | Подсветка, отступы, скобки |
| snippets/bsl.json | Сниппеты |
| src/lib.rs | Rust WASM-расширение |
| **opencode.json** | **Конфигурация OpenCode** |
| **.opencode/skills/1c-bsl.md** | **Skill для 1C** |
| PLAN.md | План (читать при старте) |
| TZ.md | Техзадание |
| AUDIT.md | Протокол разработки |

## Правила
1. Перед правкой .scm → эталон vsc-language-1c-bsl
2. grammars/ → только если менять парсер
3. После изменений → обновить PLAN.md и AUDIT.md
4. Для OpenCode: обновлять opencode.json и .opencode/skills/1c-bsl.md
