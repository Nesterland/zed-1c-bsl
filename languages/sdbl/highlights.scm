; =============================================================================
; 1C SDBL — Подсветка синтаксиса для Zed
; Версия: 0.0.2
; Основано на: tree-sitter-bsl (alkoleft), vsc-language-1c-bsl (1c-syntax)
; =============================================================================

; -----------------------------------------------------------------------------
; 1. Комментарии
; -----------------------------------------------------------------------------
(line_comment) @comment

; -----------------------------------------------------------------------------
; 2. Константы (Неопределено, Истина, Ложь, NULL)
; -----------------------------------------------------------------------------
[
  (TRUE_KEYWORD)
  (FALSE_KEYWORD)
  (NULL_KEYWORD)
  (UNDEFINED_KEYWORD)
] @constant.builtin

; -----------------------------------------------------------------------------
; 3. Ключевые слова запроса (keyword)
; -----------------------------------------------------------------------------
[
  (SELECT_KEYWORD)
  (ALLOWED_KEYWORD)
  (ALL_KEYWORD)
  (DISTINCT_KEYWORD)
  (TOP_KEYWORD)
  (AS_KEYWORD)
  (FROM_KEYWORD)
  (WHERE_KEYWORD)
  (GROUP_KEYWORD)
  (BY_KEYWORD)
  (HAVING_KEYWORD)
  (ORDER_KEYWORD)
  (ASC_KEYWORD)
  (DESC_KEYWORD)
  (AUTO_ORDER_KEYWORD)
  (UNION_KEYWORD)
  (TOTALS_KEYWORD)
  (INTO_KEYWORD)
  (UPDATE_KEYWORD)
  (INDEX_KEYWORD)
  (DESTROY_KEYWORD)
  (EMPTY_TABLE_KEYWORD)
  (INNER_KEYWORD)
  (LEFT_KEYWORD)
  (RIGHT_KEYWORD)
  (FULL_KEYWORD)
  (OUTER_KEYWORD)
  (JOIN_KEYWORD)
  (ON_KEYWORD)
  (HIERARCHY_KEYWORD)
  (ONLY_KEYWORD)
  (PERIODS_KEYWORD)
  (REFERENCE_KEYWORD)
  (SPECIALCHAR_KEYWORD)
] @keyword

; -----------------------------------------------------------------------------
; 4. Логические операторы (keyword.operator)
; -----------------------------------------------------------------------------
[
  (AND_KEYWORD)
  (OR_KEYWORD)
  (NOT_KEYWORD)
  (IN_KEYWORD)
  (IS_KEYWORD)
  (LIKE_KEYWORD)
  (BETWEEN_KEYWORD)
] @keyword.operator

; -----------------------------------------------------------------------------
; 5. CASE / WHEN / THEN / ELSE / END (keyword.control)
; -----------------------------------------------------------------------------
[
  (CASE_KEYWORD)
  (WHEN_KEYWORD)
  (THEN_KEYWORD)
  (ELSE_KEYWORD)
  (END_KEYWORD)
] @keyword.control

; -----------------------------------------------------------------------------
; 6. Типы SDBL (type)
; -----------------------------------------------------------------------------
[
  (TYPE_KEYWORD)
  (BOOLEAN_TYPE_KEYWORD)
  (DATE_TYPE_KEYWORD)
  (NUMBER_TYPE_KEYWORD)
  (STRING_TYPE_KEYWORD)
  (VALUE_KEYWORD)
] @type

; -----------------------------------------------------------------------------
; 7. FOR UPDATE OF (keyword.control)
; -----------------------------------------------------------------------------
[
  (FOR_KEYWORD)
  (OF_KEYWORD)
] @keyword.control

; -----------------------------------------------------------------------------
; 8. Даты (constant)
; -----------------------------------------------------------------------------
[
  (DAY_KEYWORD)
  (HALF_YEAR_KEYWORD)
  (HOUR_KEYWORD)
  (MINUTE_KEYWORD)
  (MONTH_KEYWORD)
  (QUARTER_KEYWORD)
  (SECOND_KEYWORD)
  (TEN_DAYS_KEYWORD)
  (WEEK_KEYWORD)
  (YEAR_KEYWORD)
] @constant

; -----------------------------------------------------------------------------
; 9. Встроенные функции SDBL (function.builtin)
; -----------------------------------------------------------------------------
; Агрегатные функции
((aggregate_function
  name: (aggregate_function_name) @function.builtin)
  (#set! priority 110))

; Неагрегатные функции
((function_call
  name: (identifier) @function.builtin)
  (#set! priority 110))

; -----------------------------------------------------------------------------
; 10. Параметры запроса (&Параметр)
; -----------------------------------------------------------------------------
((parameter) @constant.builtin
  (#set! priority 120))

((parameter
  "&" @constant.builtin
  (identifier) @constant.builtin)
  (#set! priority 120))

; -----------------------------------------------------------------------------
; 11. Идентификаторы и переменные
; -----------------------------------------------------------------------------
((identifier) @variable
  (#set! priority 95))
((dotted_identifier) @variable
  (#set! priority 95))

; -----------------------------------------------------------------------------
; 12. Даты и числа
; -----------------------------------------------------------------------------
[
  (date)
  (date_time_literal)
] @constant

(number) @number

; -----------------------------------------------------------------------------
; 13. Строки
; -----------------------------------------------------------------------------
(string) @string

; -----------------------------------------------------------------------------
; 14. Операторы
; -----------------------------------------------------------------------------
[
  (comparison_operator)
  (arithmetic_operator)
  (not_operator)
  (sign_operator)
] @operator

; -----------------------------------------------------------------------------
; 15. Скобки
; -----------------------------------------------------------------------------
[
  "("
  ")"
] @punctuation.bracket

; -----------------------------------------------------------------------------
; 16. Разделители
; -----------------------------------------------------------------------------
[
  ";"
  "."
  ","
] @punctuation.delimiter
