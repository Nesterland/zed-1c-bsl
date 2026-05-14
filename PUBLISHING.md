# Публикация расширения 1C BSL в каталог Zed

Пошаговая инструкция по публикации расширения в [Zed Extension Marketplace](https://zed.dev/extensions).

## Пререквизиты

- [x] Расширение имеет уникальный ID: `1c-bsl`
- [x] Лицензия MIT в корне репозитория (`LICENSE`)
- [x] Все обязательные поля в `extension.toml` заполнены
- [x] Расширение не содержит посторонних тем/иконок
- [x] Расширение не поставляет language server — пользователь настраивает сам
- [ ] Расширение протестировано локально через `Install Dev Extension`

## Чек-лист перед публикацией

### 1. Проверить ID и имя

```toml
# extension.toml
id = "1c-bsl"
name = "1C BSL"
```

- ✅ Не содержит слов `zed`, `Zed`, `extension`
- ✅ ID описывает назначение: язык BSL для 1C
- ✅ ID следует конвенции: `язык-платформа`

### 2. Проверить лицензию

- ✅ `LICENSE` — MIT (в списке разрешённых: Apache 2.0, BSD 2-Clause, BSD 3-Clause, CC BY 4.0, GPLv3, LGPLv3, MIT, Unlicense, zlib)
- ✅ Файл в корне расширения

### 3. Проверить семантическое версионирование

- ✅ `version = "0.0.3"` в `extension.toml`
- ✅ Эта же версия будет указана в `extensions.toml` при PR

### 4. Протестировать локально

```bash
# В Zed:
# 1. Открыть Extensions (Ctrl+Shift+X)
# 2. Нажать "Install Dev Extension"
# 3. Выбрать папку проекта
# 4. Открыть examples/basic.bsl — проверить:
#    - Подсветку синтаксиса
#    - Авто-отступы (Enter внутри блока)
#    - Сниппеты (набрать "Процедура" → Tab)
#    - Outline (Ctrl+Shift+O)
# 5. При ошибках: zed: open log → искать ошибки grammar/extension
```

### 5. Убедиться, что репозиторий публичный

```bash
# Репозиторий должен быть доступен без аутентификации:
# https://github.com/Nesterland/zed-1c-bsl
```

## Процесс публикации

### Шаг 1: Fork `zed-industries/extensions`

```bash
# Сделать fork через GitHub UI:
# https://github.com/zed-industries/extensions/fork

# Клонировать свой fork:
git clone https://github.com/Nesterland/extensions
cd extensions

# Инициализировать submodules:
git submodule init
git submodule update
```

### Шаг 2: Добавить расширение как submodule

```bash
# Из корня extensions/
git submodule add https://github.com/Nesterland/zed-1c-bsl.git extensions/1c-bsl

# Убедиться, что URL HTTPS (не git@github.com):
git config --file=.gitmodules submodule.extensions/1c-bsl.url
# Должен вывести: https://github.com/Nesterland/zed-1c-bsl.git

# Убедиться, что submodule на ветке (не detached HEAD):
cd extensions/1c-bsl
git branch
# Должен показать main или master
```

### Шаг 3: Добавить запись в `extensions.toml`

```toml
# В корне extensions/extensions.toml добавить:
[1c-bsl]
submodule = "extensions/1c-bsl"
version = "0.0.3"
```

### Шаг 4: Отсортировать

```bash
# Установить pnpm если ещё нет:
npm install -g pnpm

# Запустить сортировку:
pnpm sort-extensions
```

### Шаг 5: Закоммитить и открыть PR

```bash
git checkout -b add-1c-bsl-extension
git add extensions/1c-bsl
git add extensions.toml .gitmodules
git commit -m "Add 1c-bsl extension v0.0.3"

git push origin add-1c-bsl-extension

# Открыть PR через GitHub UI в zed-industries/extensions
```

### Шаг 6: После мёрджа

После того как PR будет принят и вмёрджен:

1. CI/CD `zed-industries/extensions` соберёт WASM-пакет
2. Расширение появится в [каталоге расширений Zed](https://zed.dev/extensions)
3. Пользователи смогут установить его через `zed: extensions` → поиск «1C BSL»

## Обновление расширения

При выходе новой версии (например, v0.1.0):

```bash
# Из корня своего clone extensions/
cd extensions

# Переключиться на main и подтянуть изменения:
git checkout main
git pull upstream main

# Обновить submodule до нужного коммита:
cd extensions/1c-bsl
git pull origin main
cd ../..

# Обновить версию в extensions.toml:
# [1c-bsl]
# submodule = "extensions/1c-bsl"
# version = "0.1.0"

# Открыть новый PR
```

## Автоматизация (GitHub Action)

Для автоматического создания PR с обновлением версии можно использовать:

- [extension-update-action](https://github.com/nicedoc/extension-update-action) — community action

## Ссылки

- [Документация: Developing Extensions](https://zed.dev/docs/extensions/developing-extensions)
- [Расширение 1C BSL](https://github.com/Nesterland/zed-1c-bsl)
- [Реестр расширений Zed](https://github.com/zed-industries/extensions)
- [Tree-sitter BSL](https://github.com/alkoleft/tree-sitter-bsl)
- [BSL Language Server](https://github.com/1c-syntax/bsl-language-server)
