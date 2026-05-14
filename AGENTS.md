# 1C BSL — Контекст для Zed AI

## Суть проекта
Расширение для IDE **Zed** с поддержкой **1C:Enterprise BSL**, **OneScript** и **SDBL**.
Репозиторий: https://github.com/Nesterland/zed-1c-bsl
Версия: **0.0.2** → **0.0.3**

## Что уже работает
- Подсветка синтаксиса .bsl, .osl, .sdbl через Tree-sitter
- Детализированные scope-ы: @keyword.control, @keyword.operator, @storage.modifier, @constant.builtin, @function.builtin, @variable.builtin, @variable.parameter, @label, @namespace, @keyword.directive
- Инъекция SDBL в строки BSL
- Встроенные функции глобального контекста (~150 функций)
- Сниппеты (40 штук)
- Outline, text objects, brackets

## Текущий фокус: Фаза 3
- indents.scm — авто-отступы (v1 создан, требует проверки в Zed)
- LSP-интеграция — bsl-language-server (не начато)

## План и статус
**См. PLAN.md** — полный план с отметками о выполнении и точкой остановки.
**См. TZ.md** — техническое задание.

## Ключевые файлы
| Файл | Назначение |
|------|-----------|
| extension.toml | Манифест + LSP |
| languages/bsl/highlights.scm | Подсветка BSL |
| languages/bsl/indents.scm | Авто-отступы |
| languages/bsl/injections.scm | Инъекция SDBL |
| languages/bsl/brackets.scm | Парные скобки |
| languages/bsl/outline.scm | Outline |
| languages/bsl/textobjects.scm | Text objects |
| languages/sdbl/highlights.scm | Подсветка SDBL |
| languages/sdbl-embedded/highlights.scm | Встроенный SDBL |
| snippets/bsl.json | Сниппеты |
| PLAN.md | План (читать при старте) |
| TZ.md | Техзадание |
| AUDIT.md | Протокол разработки |

## Правила
1. Перед правкой .scm → эталон vsc-language-1c-bsl
2. grammars/ → только если менять парсер
3. После изменений → обновить PLAN.md и AUDIT.md
