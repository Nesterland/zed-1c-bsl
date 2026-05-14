# Настройка BSL Language Server в Zed

Расширение **1C BSL** поддерживает автодополнение, диагностику, навигацию и другие возможности через **BSL Language Server** (реализация LSP для 1C:Enterprise и OneScript).

> **Внимание:** для автоматического запуска LSP требуется Java (JVM). В будущем расширение сможет само находить Java и скачивать сервер (Фаза 4). Пока — настройка вручную.

## 1. Установка BSL Language Server

Скачайте JAR-файл с [GitHub Releases](https://github.com/1c-syntax/bsl-language-server/releases):

```bash
# Пример: скачать последнюю версию
wget https://github.com/1c-syntax/bsl-language-server/releases/download/v0.9.0/bsl-language-server.jar -O ~/bin/bsl-language-server.jar
```

Или через расширение VS Code — оно автоматически скачивает JAR в кэш.

## 2. Настройка в Zed

Добавьте в `settings.json` (Zed → Open Settings):

```json
{
  "lsp": {
    "bsl": {
      "binary": {
        "path": "java",
        "arguments": [
          "-Xmx2g",
          "-jar",
          "bsl-language-server.jar"
        ]
      }
    }
  }
}
```

**Важно:** укажите **абсолютный путь** к JAR-файлу, если он не в текущей директории:

```json
{
  "lsp": {
    "bsl": {
      "binary": {
        "path": "java",
        "arguments": [
          "-Xmx2g",
          "-jar",
          "/home/user/bin/bsl-language-server.jar"
        ]
      }
    }
  }
}
```

Или можно использовать переменную окружения `PATH`, разместив JAR в одной из системных директорий.

## 3. Конфигурация проекта (опционально)

Создайте файл `.bsl-language-server.json` в корне вашего проекта:

```json
{
  "language": "en",
  "diagnostics": {
    "lineLength": {
      "maxLineLength": 140
    }
  }
}
```

Подробнее: https://1c-syntax.github.io/bsl-language-server/configuration

## 4. Проверка

1. Откройте любой `.bsl` файл в своём проекте
2. В строке состояния Zed должен появиться индикатор BSL LSP
3. Ctrl+Shift+I (или View → LSP Log) — проверьте логи на предмет ошибок
4. Наведите курсор на имя процедуры — должен появиться hover с информацией

## 5. Возможности

После успешной настройки доступны:

- ✔ Диагностика (ошибки, предупреждения)
- ✔ Автодополнение (встроенные функции глобального контекста, процедуры)
- ✔ Hover (информация по наведению)
- ✔ Go to Definition (переход к определению)
- ✔ Find References (поиск использований)
- ✔ Rename (переименование символов)
- ✔ Code Actions (быстрые исправления)
- ✔ Semantic Tokens (семантическая подсветка)
- ✔ Folding (сворачивание блоков)
- ✔ Inlay Hints (подсказки о типах)

## 6. Устранение проблем

| Проблема | Решение |
|----------|---------|
| Не видит Java | Убедитесь, что `java` доступна в PATH: `java -version` |
| Ошибка памяти | Увеличьте `-Xmx2g` → `-Xmx4g` |
| Не подключается к LSP | Проверьте логи: Ctrl+Shift+I → LSP Log |
| Не скачивается JAR | Проверьте URL и доступ к GitHub |
| BSL LSP не запускается | Попробуйте запустить вручную: `java -jar bsl-language-server.jar --lsp` |
