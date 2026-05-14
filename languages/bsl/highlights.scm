; =============================================================================
; 1C BSL — Подсветка синтаксиса для Zed
; Версия: 0.0.2
; Основано на: tree-sitter-bsl (alkoleft), vsc-language-1c-bsl (1c-syntax)
; =============================================================================

; -----------------------------------------------------------------------------
; 1. Комментарии
; -----------------------------------------------------------------------------
(line_comment) @comment

; -----------------------------------------------------------------------------
; 2. Константы (Истина, Ложь, Неопределено, NULL)
; -----------------------------------------------------------------------------
[
  (TRUE_KEYWORD)
  (FALSE_KEYWORD)
  (UNDEFINED_KEYWORD)
  (NULL_KEYWORD)
] @constant.builtin

; -----------------------------------------------------------------------------
; 3. Управляющие конструкции (keyword.control)
; -----------------------------------------------------------------------------
; Условия
[
  (IF_KEYWORD)
  (THEN_KEYWORD)
  (ELSE_KEYWORD)
  (ELSIF_KEYWORD)
  (ENDIF_KEYWORD)
] @keyword.control

; Циклы
[
  (FOR_KEYWORD)
  (EACH_KEYWORD)
  (WHILE_KEYWORD)
  (DO_KEYWORD)
  (ENDDO_KEYWORD)
] @keyword.control

; Цикл Для ... По ... Цикл (IN и TO в for/in/to контексте)
[
  (IN_KEYWORD)
  (TO_KEYWORD)
] @keyword.control

; Исключения
[
  (TRY_KEYWORD)
  (EXCEPT_KEYWORD)
  (ENDTRY_KEYWORD)
  (RAISE_KEYWORD)
] @keyword.control

; Переходы
[
  (RETURN_KEYWORD)
  (BREAK_KEYWORD)
  (CONTINUE_KEYWORD)
  (GOTO_KEYWORD)
] @keyword.control

; -----------------------------------------------------------------------------
; 4. Объявления (keyword)
; -----------------------------------------------------------------------------
[
  (PROCEDURE_KEYWORD)
  (ENDPROCEDURE_KEYWORD)
  (FUNCTION_KEYWORD)
  (ENDFUNCTION_KEYWORD)
  (VAR_KEYWORD)
] @keyword

; -----------------------------------------------------------------------------
; 5. Модификаторы (storage.modifier)
; -----------------------------------------------------------------------------
[
  (EXPORT_KEYWORD)
  (VAL_KEYWORD)
  (ASYNC_KEYWORD)
] @storage.modifier

; -----------------------------------------------------------------------------
; 6. Логические операторы (keyword.operator)
; -----------------------------------------------------------------------------
[
  (AND_KEYWORD)
  (OR_KEYWORD)
  (NOT_KEYWORD)
] @keyword.operator

; -----------------------------------------------------------------------------
; 7. Асинхронность
; -----------------------------------------------------------------------------
(AWAIT_KEYWORD) @keyword.control

; -----------------------------------------------------------------------------
; 8. Обработчики
; -----------------------------------------------------------------------------
[
  (ADDHANDLER_KEYWORD)
  (REMOVEHANDLER_KEYWORD)
] @keyword

; -----------------------------------------------------------------------------
; 9. Конструктор
; -----------------------------------------------------------------------------
(NEW_KEYWORD) @constructor

; -----------------------------------------------------------------------------
; 10. Препроцессор (keyword.directive)
; -----------------------------------------------------------------------------
[
  (PREPROC_IF_KEYWORD)
  (PREPROC_ELSE_KEYWORD)
  (PREPROC_ELSIF_KEYWORD)
  (PREPROC_ENDIF_KEYWORD)
  (PREPROC_REGION_KEYWORD)
  (PREPROC_ENDREGION_KEYWORD)
  (preproc)
] @keyword.directive

; Имя области (#Область ИмяОбласти)
(preprocessor
  (PREPROC_REGION_KEYWORD)
  name: (identifier) @namespace)

; -----------------------------------------------------------------------------
; 11. Аннотации и директивы компиляции
; -----------------------------------------------------------------------------
(annotation) @attribute

; -----------------------------------------------------------------------------
; 12. Процедуры и функции
; -----------------------------------------------------------------------------
(procedure_definition
  name: (identifier) @function)

(function_definition
  name: (identifier) @function)

; Вызовы методов
(method_call
  name: (identifier) @function)

; Выражения вызова
(call_expression) @function.call

; -----------------------------------------------------------------------------
; 13. Встроенные функции глобального контекста
;     (основано на vsc-language-1c-bsl syntaxes/1c.tmLanguage.json)
; -----------------------------------------------------------------------------
; ... Строки
((identifier) @function.builtin
  (#match? @function.builtin "^(СтрДлина|StrLen|СокрЛ|TrimL|СокрП|TrimR|СокрЛП|TrimAll|Лев|Left|Прав|Right|Сред|Mid|СтрНайти|StrFind|ВРег|Upper|НРег|Lower|ТРег|Title|Символ|Char|КодСимвола|CharCode|ПустаяСтрока|IsBlankString|СтрЗаменить|StrReplace|СтрЧислоСтрок|StrLineCount|СтрПолучитьСтроку|StrGetLine|СтрЧислоВхождений|StrOccurrenceCount|СтрСравнить|StrCompare|СтрНачинаетсяС|StrStartWith|СтрЗаканчиваетсяНа|StrEndsWith|СтрРазделить|StrSplit|СтрСоединить|StrConcat)$"))

; ... Числа
((identifier) @function.builtin
  (#match? @function.builtin "^(Цел|Int|Окр|Round|ACos|ASin|ATan|Cos|Exp|Log|Log10|Pow|Sin|Sqrt|Tan)$"))

; ... Даты
((identifier) @function.builtin
  (#match? @function.builtin "^(Год|Year|Месяц|Month|День|Day|Час|Hour|Минута|Minute|Секунда|Second|НачалоГода|BegOfYear|НачалоДня|BegOfDay|НачалоКвартала|BegOfQuarter|НачалоМесяца|BegOfMonth|НачалоМинуты|BegOfMinute|НачалоНедели|BegOfWeek|НачалоЧаса|BegOfHour|КонецГода|EndOfYear|КонецДня|EndOfDay|КонецКвартала|EndOfQuarter|КонецМесяца|EndOfMonth|КонецМинуты|EndOfMinute|КонецНедели|EndOfWeek|КонецЧаса|EndOfHour|НеделяГода|WeekOfYear|ДеньГода|DayOfYear|ДеньНедели|WeekDay|ТекущаяДата|CurrentDate|ДобавитьМесяц|AddMonth)$"))

; ... Типы
((identifier) @function.builtin
  (#match? @function.builtin "^(Тип|Type|ТипЗнч|TypeOf|Булево|Boolean|Число|Number|Строка|String|Дата|Date)$"))

; ... Интерактивные
((identifier) @function.builtin
  (#match? @function.builtin "^(Сообщить|Message|ОчиститьСообщения|ClearMessages|ПоказатьВопрос|ShowQueryBox|Вопрос|DoQueryBox|ПоказатьПредупреждение|ShowMessageBox|Предупреждение|DoMessageBox|ОповеститьОбИзменении|NotifyChanged|Состояние|Status|Сигнал|Beep|ПоказатьЗначение|ShowValue|ОткрытьЗначение|OpenValue|Оповестить|Notify|ПоказатьВводЗначения|ShowInputValue|ВвестиЗначение|InputValue|ПоказатьВводЧисла|ShowInputNumber|ВвестиЧисло|InputNumber|ПоказатьВводСтроки|ShowInputString|ВвестиСтроку|InputString|ПоказатьВводДаты|ShowInputDate|ВвестиДату|InputDate)$"))

; ... Форматирование
((identifier) @function.builtin
  (#match? @function.builtin "^(Формат|Format|ЧислоПрописью|NumberInWords|НСтр|NStr|ПредставлениеПериода|PeriodPresentation|СтрШаблон|StrTemplate)$"))

; ... Файлы
((identifier) @function.builtin
  (#match? @function.builtin "^(КопироватьФайл|FileCopy|ПереместитьФайл|MoveFile|УдалитьФайлы|DeleteFiles|НайтиФайлы|FindFiles|СоздатьКаталог|CreateDirectory|ПолучитьФайл|GetFile|ПолучитьФайлы|GetFiles|ПолучитьИмяВременногоФайла|GetTempFileName|РазделитьФайл|SplitFile|ОбъединитьФайлы|MergeFiles|ПоместитьФайл|PutFile|ПоместитьФайлы|PutFiles)$"))

; ... JSON / XML
((identifier) @function.builtin
  (#match? @function.builtin "^(ЗаписатьJSON|WriteJSON|ПрочитатьJSON|ReadJSON|ПрочитатьДатуJSON|ReadJSONDate|ЗаписатьДатуJSON|WriteJSONDate|XMLСтрока|XMLString|XMLЗначение|XMLValue|XMLТип|XMLType|XMLТипЗнч|XMLTypeOf|ПрочитатьXML|ReadXML|ЗаписатьXML|WriteXML)$"))

; ... Информационная база / транзакции
((identifier) @function.builtin
  (#match? @function.builtin "^(НачатьТранзакцию|BeginTransaction|ЗафиксироватьТранзакцию|CommitTransaction|ОтменитьТранзакцию|RollbackTransaction|УстановитьМонопольныйРежим|SetExclusiveMode|МонопольныйРежим|ExclusiveMode|ПолучитьОперативнуюОтметкуВремени|GetRealTimeTimestamp|НомерСоединенияИнформационнойБазы|InfoBaseConnectionNumber|УстановитьПривилегированныйРежим|SetPrivilegedMode|ПривилегированныйРежим|PrivilegedMode|ТранзакцияАктивна|TransactionActive)$"))

; ... Глобальный контекст — свойства (классы)
((identifier) @variable.builtin
  (#match? @variable.builtin "^(Метаданные|Metadata|Справочники|Catalogs|Документы|Documents|РегистрыСведений|InformationRegisters|РегистрыНакопления|AccumulationRegisters|РегистрыБухгалтерии|AccountingRegisters|РегистрыРасчета|CalculationRegisters|ПланыСчетов|ChartsOfAccounts|ПланыВидовХарактеристик|ChartsOfCharacteristicTypes|ПланыВидовРасчета|ChartsOfCalculationTypes|ПланыОбмена|ExchangePlans|Перечисления|Enums|Константы|Constants|БизнесПроцессы|BusinessProcesses|Задачи|Tasks|Обработки|DataProcessors|Отчеты|Reports|Последовательности|Sequences|ЖурналыДокументов|DocumentJournals|ПараметрыСеанса|SessionParameters|ХранилищаНастроек|SettingsStorages|РегламентныеЗадания|ScheduledJobs|ФоновыеЗадания|BackgroundJobs|БиблиотекаКартинок|PictureLib|ФабрикаXDTO|XDTOFactory|СериализаторXDTO|XDTOSerializer|ПользователиИнформационнойБазы|InfoBaseUsers|ВнешниеИсточникиДанных|ExternalDataSources|РасширенияКонфигурации|ConfigurationExtensions|СредстваКриптографии|CryptoToolsManager|СредстваПочты|MailTools|СредстваТелефонии|TelephonyTools|СредстваМультимедиа|MultimediaTools|ФайловыеПотоки|FileStreams)$"))

; ... Глобальный контекст — переменные
((identifier) @variable.builtin
  (#match? @variable.builtin "^(РабочаяДата|WorkingDate|ГлавныйИнтерфейс|MainInterface|ГлавныйСтиль|MainStyle|ПараметрЗапуска|LaunchParameter)$"))

; ... Прочие встроенные функции
((identifier) @function.builtin
  (#match? @function.builtin "^(Мин|Min|Макс|Max|Вычислить|Eval|ОписаниеОшибки|ErrorDescription|ИнформацияОбОшибке|ErrorInfo|Base64Значение|Base64Value|Base64Строка|Base64String|ЗаполнитьЗначенияСвойств|FillPropertyValues|ЗначениеЗаполнено|ValueIsFilled|Найти|Find)$"))

; -----------------------------------------------------------------------------
; 14. Переменные и параметры
; -----------------------------------------------------------------------------
; Объявления Перем
(var_definition
  _var_definition_variables
  (variable_spec
    name: (identifier) @variable))

; Параметры процедур и функций
(parameter
  name: (identifier) @variable.parameter)

; -----------------------------------------------------------------------------
; 15. Метки (~метка:)
; -----------------------------------------------------------------------------
(label_statement
  (identifier) @label)

; -----------------------------------------------------------------------------
; 16. Строки
; -----------------------------------------------------------------------------
[
  (string)
  (string_content)
] @string

; -----------------------------------------------------------------------------
; 17. Даты
; -----------------------------------------------------------------------------
(date) @constant

; -----------------------------------------------------------------------------
; 18. Числа
; -----------------------------------------------------------------------------
(number) @number

; -----------------------------------------------------------------------------
; 19. Операторы
; -----------------------------------------------------------------------------
(operator) @operator

; -----------------------------------------------------------------------------
; 20. Скобки
; -----------------------------------------------------------------------------
[
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

; -----------------------------------------------------------------------------
; 21. Разделители
; -----------------------------------------------------------------------------
[
  ";"
  "."
  ","
] @punctuation.delimiter
