# Testing Checklist for v0.1.0

## Prerequisites

- Zed installed (0.163+)
- This project folder accessible from Zed
- Java 17+ installed (`java -version`)
- `JAVA_HOME` set **or** `java` in PATH

---

## 1. Install the Extension in Zed

```
1. Open Zed
2. Ctrl+Shift+E (Extensions)
3. Click "Install Dev Extension"
4. Select the BSL folder (D:\Work_Nesterland\Cursor\BSL)
5. Wait for grammar compilation
```

**Check:** No errors in `zed: open log` (search for `1c-bsl` or `error`).

---

## 2. Syntax Highlighting

Open `examples/basic.bsl`.

| # | What to check | Expected |
|---|---------------|----------|
| 2.1 | Keywords (`Процедура`, `КонецПроцедуры`, `Если`, `Тогда`) | Colored distinctly from identifiers |
| 2.2 | Built-in functions (`Сообщить`, `Новый`, `ОписаниеОшибки`) | Highlighted as `@function.builtin` |
| 2.3 | Global context (`Метаданные`, `Справочники`, `Перечисления`) | Highlighted as `@variable.builtin` |
| 2.4 | Strings (`"Привет, мир!"`) | String color |
| 2.5 | Dates (`'20250120'`) | Constant color |
| 2.6 | Comments (`//`) | Comment color |
| 2.7 | Preprocessor (`#Область`, `&НаКлиенте`) | Directive color |
| 2.8 | Embedded SDBL string `"ВЫБРАТЬ ..."` | Query keywords highlighted inside the string |

**How to verify:** Open `zed: open log`, search for `compiling query`. If there's an error with `highlights.scm`, highlighting will be blank — this means a node name is wrong.

---

## 3. Embedded SDBL Injection

Open `examples/basic.bsl`, find the query string:

```bsl
Запрос.Текст = "ВЫБРАТЬ
    |   Номенклатура.Ссылка КАК Ссылка
    |ИЗ
    |   Справочник.Номенклатура КАК Номенклатура
    |ГДЕ
    |   Номенклатура.ПометкаУдаления = ЛОЖЬ";
```

**Check:** `ВЫБРАТЬ`, `КАК`, `ИЗ`, `ГДЕ`, `ЛОЖЬ` — highlighted with SDBL colors (not plain string color).

Also test `УНИЧТОЖИТЬ`/`DROP`:

```bsl
Текст = "УНИЧТОЖИТЬ Справочник.Номенклатура";
```

**Check:** `УНИЧТОЖИТЬ` highlighted as SDBL keyword.

---

## 4. Auto-Indentation

Open `examples/basic.bsl`.

| # | Test | Expected |
|---|------|----------|
| 4.1 | Line after `Процедура ...` + Enter | Indent +4 |
| 4.2 | Type `КонецПроцедуры` | Outdent back |
| 4.3 | Line after `Если ... Тогда` + Enter | Indent +4 |
| 4.4 | Type `КонецЕсли` | Outdent back |
| 4.5 | `Иначе` inside `Если` | Outdent to match `Если` level |
| 4.6 | `Для ... Цикл` + Enter | Indent +4 |
| 4.7 | `КонецЦикла` | Outdent back |
| 4.8 | `Попытка` + Enter | Indent +4 |
| 4.9 | `КонецПопытки` | Outdent back |
| 4.10 | `#Область ...` + Enter | Indent +4 |
| 4.11 | `#КонецОбласти` | Outdent back |
| 4.12 | `Новый Структура(` + Enter | Indent +4 for parameters |

**If indents don't work:** Check `zed: open log` for errors compiling `indents.scm`. If the file is broken, indents silently fail.

---

## 5. Snippets

Open a `.bsl` file, type a snippet prefix + Tab.

| # | Prefix | Should expand to |
|---|--------|-----------------|
| 5.1 | `proc` | `Процедура ... КонецПроцедуры` |
| 5.2 | `func` | `Функция ... КонецФункции` |
| 5.3 | `if` | `Если ... Тогда ... КонецЕсли` |
| 5.4 | `for` | `Для ... По ... Цикл ... КонецЦикла` |
| 5.5 | `while` | `Пока ... Цикл ... КонецЦикла` |
| 5.6 | `try` | `Попытка ... Исключение ... КонецПопытки` |
| 5.7 | `reg` | `#Область ... #КонецОбласти` |

---

## 6. Outline & Text Objects

| # | Test | How |
|---|------|-----|
| 6.1 | Outline | `Ctrl+Shift+O` — should list procedures and functions |
| 6.2 | Fold `#Область` | Click fold arrow next to `#Область` line |

**Note:** Folding requires the region body to be **indented**.

---

## 7. Bracket Matching

| # | Test | Expected |
|---|------|----------|
| 7.1 | Cursor on `(` | Matching `)` highlighted |
| 7.2 | Cursor on `[` | Matching `]` highlighted |
| 7.3 | Cursor on `"` | Matching `"` highlighted |

---

## 8. WASM / LSP (v0.1.0)

This is the key new feature for v0.1.0.

**Before testing:**
```bash
# Clear any cached JAR (forces fresh download)
rm -rf ~/.cache/zed/bsl-language-server
```

**Steps:**

```
1. Open any .bsl file
2. Wait 10-30 seconds (first launch: JAR download from GitHub)
3. Check the status bar — LSP indicator should appear for BSL
4. Open `zed: open log`
5. Search for "bsl" or "language_server_command"
```

| # | Check | What to look for in log |
|---|-------|------------------------|
| 8.1 | Java found | Log shows Java path (from JAVA_HOME) or "java" |
| 8.2 | JAR download | Log shows `download_file` call to `github.com/1c-syntax/bsl-language-server` |
| 8.3 | LSP started | `language_server_command` returns successfully |
| 8.4 | LSP indicator | Status bar shows BSL LSP icon (bottom right) |
| 8.5 | Diagnostics | Any syntax errors in `.bsl` file appear as red squiggles |
| 8.6 | Hover | Hover over `Сообщить` — should show function signature |
| 8.7 | Autocompletion | Type `Стр` — should list `СтрДлина`, `Строка`, etc. |
| 8.8 | Go-to-def | Ctrl+Click on a procedure name — should navigate |

**If WASM doesn't work:**

- Check `zed: open log` for `error` near `1c-bsl` or `wasm`
- The most likely issues:
  - `Java not found` → install Java 17+
  - `Failed to download JAR` → check internet / GitHub access
  - WASM not loaded → check `extension.toml` has `wasm = true`

### Fallback: Manual LSP

If WASM doesn't run, test LSP the old way:

```json
// settings.json
{
  "lsp": {
    "bsl": {
      "binary": {
        "path": "java",
        "arguments": ["-Xmx2g", "-jar", "bsl-language-server.jar"]
      }
    }
  }
}
```

Download the JAR manually from https://github.com/1c-syntax/bsl-language-server/releases.

---

## 9. Quick Sanity Test

Create a new test file `test.bsl`:

```bsl
&НаКлиенте
Процедура Тест(Знач Имя)
    Если Имя = Неопределено Тогда
        Сообщить("Привет!");
    КонецЕсли;
КонецПроцедуры
```

**Checklist:**
- [ ] Keywords colored correctly
- [ ] Indent works after `Процедура` and `Если`
- [ ] LSP shows no errors (or meaningful ones)
- [ ] Hover on `Сообщить` shows signature

---

## Results

| # | Test | Pass/Fail | Notes |
|---|------|-----------|-------|
| 2 | Syntax Highlighting | ⬜ | |
| 3 | SDBL Injection | ⬜ | |
| 4 | Auto-Indentation | ⬜ | |
| 5 | Snippets | ⬜ | |
| 6 | Outline & Folding | ⬜ | |
| 7 | Bracket Matching | ⬜ | |
| 8 | WASM / LSP | ⬜ | |
| 9 | Sanity | ⬜ | |
