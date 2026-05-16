; =============================================================================
; 1C BSL — Подсветка синтаксиса для Zed
; Версия: 0.1.2
; Основано на: tree-sitter-bsl (alkoleft), vsc-language-1c-bsl (1c-syntax)
; =============================================================================

; -----------------------------------------------------------------------------
; Таблица scope'ов Zed:
;   @constructor        — Новый
;   @type               — тип после Новый (Новый Структура)
;   @variable           — переменные по умолчанию
;   @variable.parameter — параметры процедур/функций
;   @variable.member    — свойства объекта (Объект.Свойство)
;   @variable.builtin   — встроенные свойства глобального контекста
;   @function           — имена процедур/функций, вызовы методов
;   @function.call      — вызов функции через точку
;   @function.builtin   — встроенные функции глобального контекста
;   @keyword            — объявления (Процедура, КонецПроцедуры, Перем)
;   @keyword.control    — условия, циклы, исключения, переходы
;   @keyword.operator   — логические операторы (И, ИЛИ, НЕ)
;   @keyword.directive  — препроцессор (#Если, #Область)
;   @storage.modifier   — модификаторы (Экспорт, Знач, Асинх)
;   @namespace          — имя #Области
;   @attribute          — аннотации и директивы компиляции (&НаКлиенте)
;   @label              — метки (~метка:)
;   @constant           — даты и значения по умолчанию параметров
;   @constant.builtin   — Истина, Ложь, Неопределено, NULL
;   @number             — числа
;   @string             — строки
;   @operator           — операторы (+, -, *, /, =, <>, ...)
;   @punctuation.bracket — скобки
;   @punctuation.delimiter — ; , .
;   @comment            — // комментарии
;
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
; 5. Модификаторы (keyword — для гарантированного цвета в теме)
; -----------------------------------------------------------------------------
; Экспорт / Val / Асинх
; Используем @keyword чтобы гарантированно был видимый цвет в любой теме
[
  (EXPORT_KEYWORD)
  (VAL_KEYWORD)
  (ASYNC_KEYWORD)
] @keyword

; Экспорт в объявлении процедуры (поле export)
(procedure_definition
  export: (EXPORT_KEYWORD) @keyword)

; Экспорт в объявлении функции (поле export)
(function_definition
  export: (EXPORT_KEYWORD) @keyword)

; Экспорт в объявлении Перем (поле export)
(var_definition
  export: (EXPORT_KEYWORD) @keyword)

; Экспорт в variable_spec (Перем Имя Экспорт)
(variable_spec
  export: (EXPORT_KEYWORD) @keyword)

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

; Тип после Новый (Новый Структура, Новый Массив)
(new_expression
  type: (identifier) @type)

; Тип в Новый(...) (Новый(Тип, Аргументы))
; Примечание: new_expression_method.type = expression — inline-тип,
; нельзя захватить как named node. Пропускаем, чтобы не ломать компиляцию.
; (new_expression_method type: (identifier) @type) ; ← вызывает ошибку компиляции

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
; 12. Идентификаторы по умолчанию — catch-all (ПЕРВЫМ!)
;     В Zed МЕНЬШИЙ номер pattern = проигрывает. Все специфичные captures
;     размещены НИЖЕ (секции 13-21) с БОЛЬШИМ номером pattern и побеждают.
; -----------------------------------------------------------------------------
(identifier) @variable

; -----------------------------------------------------------------------------
; 13. Процедуры и функции
; -----------------------------------------------------------------------------
(procedure_definition
  name: (identifier) @function)

(function_definition
  name: (identifier) @function)

; Вызовы методов объектов (Объект.Метод)
(method_call
  name: (identifier) @function)

; Выражения вызова — подсвечиваем только имя вызываемой функции
(call_expression
  (access
    (identifier) @function.call))

; Свойства объектов (Объект.Свойство)
(property) @variable.member

; -----------------------------------------------------------------------------
; 14. Встроенные функции глобального контекста (ПЕРЕОПРЕДЕЛЯЮТ catch-all)
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

; ... Конфигурация (общие макеты, предопределённые значения)
((identifier) @function.builtin
  (#match? @function.builtin "^(ПолучитьОбщийМакет|GetCommonTemplate|ПолучитьОбщуюФорму|GetCommonForm|ПредопределенноеЗначение|PredefinedValue|ПолучитьПолноеИмяПредопределенногоЗначения|GetPredefinedValueFullName)$"))

; ... Сеанс работы (заголовки, пользователи, языки)
((identifier) @function.builtin
  (#match? @function.builtin "^(ПолучитьЗаголовокСистемы|GetCaption|УстановитьЗаголовокСистемы|SetCaption|ИмяКомпьютера|ComputerName|ИмяПользователя|UserName|ПолноеИмяПользователя|UserFullName|ТекущийЯзык|CurrentLanguage|ТекущийКодЛокализации|CurrentLocaleCode|ЗавершитьРаботуСистемы|Exit|СтрокаСоединенияИнформационнойБазы|InfoBaseConnectionString|ПравоДоступа|AccessRight|РольДоступна|IsInRole|ТекущийЯзыкСистемы|CurrentSystemLanguage|ТекущийРежимЗапуска|CurrentRunMode|ТекущаяДатаСеанса|CurrentSessionDate|ПараметрыДоступа|AccessParameters)$"))

; ... ОС и внешние компоненты
((identifier) @function.builtin
  (#match? @function.builtin "^(КомандаСистемы|System|ЗапуститьПриложение|RunApp|ПолучитьCOMОбъект|GetCOMObject|ПодключитьВнешнююКомпоненту|AttachAddIn|УстановитьВнешнююКомпоненту|InstallAddIn)$"))

; ... Временное хранилище
((identifier) @function.builtin
  (#match? @function.builtin "^(ПоместитьВоВременноеХранилище|PutToTempStorage|ПолучитьИзВременногоХранилища|GetFromTempStorage|УдалитьИзВременногоХранилища|DeleteFromTempStorage|ЭтоАдресВременногоХранилища|IsTempStorageURL)$"))

; ... Работа с данными ИБ (поиск, удаление объектов)
((identifier) @function.builtin
  (#match? @function.builtin "^(НайтиПомеченныеНаУдаление|FindMarkedForDeletion|НайтиПоСсылкам|FindByRef|УдалитьОбъекты|DeleteObjects)$"))

; ... Журнал регистрации
((identifier) @function.builtin
  (#match? @function.builtin "^(ЗаписьЖурналаРегистрации|WriteLogEvent|ПолучитьИспользованиеЖурналаРегистрации|GetEventLogUsing|УстановитьИспользованиеЖурналаРегистрации|SetEventLogUsing|ВыгрузитьЖурналРегистрации|UnloadEventLog|ОчиститьЖурналРегистрации|ClearEventLog)$"))

; ... Навигационные ссылки и окна
((identifier) @function.builtin
  (#match? @function.builtin "^(ПолучитьНавигационнуюСсылку|GetURL|ПерейтиПоНавигационнойСсылке|GotoURL|ПолучитьОкна|GetWindows|НайтиОкноПоНавигационнойСсылке|FindWindowByURL|ПолучитьНавигационнуюСсылкуИнформационнойБазы|GetInfoBaseURL|ПолучитьПредставленияНавигационныхСсылок|GetURLsPresentations)$"))

; ... События приложения
((identifier) @function.builtin
  (#match? @function.builtin "^(ПередНачаломРаботыСистемы|BeforeStart|ПриНачалеРаботыСистемы|OnStart|ПередЗавершениемРаботыСистемы|BeforeExit|ПриЗавершенииРаботыСистемы|OnExit|ОбработкаВнешнегоСобытия|ExternEventProcessing|УстановкаПараметровСеанса|SessionParametersSetting)$"))

; ... Двоичные данные
((identifier) @function.builtin
  (#match? @function.builtin "^(СоединитьБуферыДвоичныхДанных|ConcatBinaryDataBuffers)$"))

; ... Время (универсальное / местное)
((identifier) @function.builtin
  (#match? @function.builtin "^(ТекущаяУниверсальнаяДата|CurrentUniversalDate|ТекущаяУниверсальнаяДатаВМиллисекундах|CurrentUniversalDateInMilliseconds|МестноеВремя|ToLocalTime|УниверсальноеВремя|ToUniversalTime|ЧасовойПояс|TimeZone)$"))

; ... Функциональные опции
((identifier) @function.builtin
  (#match? @function.builtin "^(ПолучитьФункциональнуюОпцию|GetFunctionalOption|ПолучитьФункциональнуюОпциюИнтерфейса|GetInterfaceFunctionalOption|ОбновитьИнтерфейс|RefreshInterface)$"))

; ... Сериализация значений
((identifier) @function.builtin
  (#match? @function.builtin "^(ЗначениеВСтрокуВнутр|ValueToStringInternal|ЗначениеИзСтрокиВнутр|ValueFromStringInternal|ЗначениеВФайл|ValueToFile|ЗначениеИзФайла|ValueFromFile|ЗначениеВДанныеФормы|ValueToFormData|ДанныеФормыВЗначение|FormDataToValue|КопироватьДанныеФормы|CopyFormData)$"))

; ... Глобальный контекст — расширенные переменные
((identifier) @variable.builtin
  (#match? @variable.builtin "^(ХранилищеВариантовОтчетов|ReportsVariantsStorage|ХранилищеНастроекДанныхФорм|FormDataSettingsStorage|ХранилищеОбщихНастроек|CommonSettingsStorage|ХранилищеПользовательскихНастроекДинамическихСписков|DynamicListsUserSettingsStorage|ХранилищеПользовательскихНастроекОтчетов|ReportsUserSettingsStorage|ХранилищеСистемныхНастроек|SystemSettingsStorage|БиблиотекаМакетовОформленияКомпоновкиДанных|DataCompositionAppearanceTemplateLib|БиблиотекаСтилей|StyleLib|ВнешниеОбработки|ExternalDataProcessors|ВнешниеОтчеты|ExternalReports|ДоставляемыеУведомления|DeliverableNotifications|ПолнотекстовыйПоиск|FullTextSearch|СредстваГеопозиционирования|LocationTools|СредстваОтображенияРекламы|AdvertisingPresentationTools)$"))

; -----------------------------------------------------------------------------
; 15. Объявления Перем и параметры (ПЕРЕОПРЕДЕЛЯЮТ catch-all)
; -----------------------------------------------------------------------------
; Объявления Перем (на уровне модуля, с возможным Экспорт)
; Примечание: _var_definition_variables — скрытый узел, его нельзя указывать в запросе.
; Переменные (variable_spec) напрямую всплывают в var_definition.
(var_definition
  (variable_spec
    name: (identifier) @variable))

; Локальный Перем (внутри процедур/функций, без Экспорт)
; var_statement — это Перем внутри тела метода, var_definition — на уровне модуля
(var_statement
  var_name: (identifier) @variable)

; Имена параметров процедур и функций
; Используем @type — в Zed variable.parameter = variable (один цвет),
; а type имеет отдельный цвет. Также @type визуально выделяет параметры.
; Примечание: parameter — именованный узел внутри parameters
(parameter
  name: (identifier) @type)

; Ключевое слово Знач (val) в параметрах
(parameter
  val: (VAL_KEYWORD) @keyword)

; Значения по умолчанию параметров (подсвечиваются как константы)
(parameter
  def: (_) @constant)

; Явный захват параметров внутри объявлений процедур (двойной захват для надёжности)
(procedure_definition
  parameters: (parameters
    (parameter
      name: (identifier) @type)))

; Явный захват параметров внутри объявлений функций
(function_definition
  parameters: (parameters
    (parameter
      name: (identifier) @type)))

; -----------------------------------------------------------------------------
; 16. Метки (~метка:) (ПЕРЕОПРЕДЕЛЯЕТ catch-all)
; -----------------------------------------------------------------------------
(label_statement
  (identifier) @label)

; -----------------------------------------------------------------------------
; 17. Строки
; -----------------------------------------------------------------------------
[
  (string)
  (string_content)
] @string

; -----------------------------------------------------------------------------
; 18. Даты
; -----------------------------------------------------------------------------
(date) @constant

; -----------------------------------------------------------------------------
; 19. Числа
; -----------------------------------------------------------------------------
(number) @number

; -----------------------------------------------------------------------------
; 20. Операторы
; -----------------------------------------------------------------------------
(operator) @operator

; -----------------------------------------------------------------------------
; 21. Скобки
; -----------------------------------------------------------------------------
[
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

; -----------------------------------------------------------------------------
; 22. Разделители
; -----------------------------------------------------------------------------
[
  ";"
  "."
  ","
] @punctuation.delimiter
