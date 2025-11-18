# 🚀 Начните здесь!

## Добро пожаловать в Planner+

Все баги исправлены, зависимости обновлены, проект готов к запуску на Arch Linux! ✅

---

## 📋 Что было исправлено

### ✅ Обновления пакетов
- **Все зависимости** обновлены до последних версий (Январь 2025)
- **Удалены** неиспользуемые пакеты (экономия места и времени сборки)
- **SDK обновлен** до 3.5.0+ для лучшей совместимости

### ✅ Arch Linux поддержка
- ✨ Автоматические скрипты установки
- 📚 Подробное руководство
- 🔧 Готовые конфигурации для всех платформ

### ✅ Платформы
- **Android** - полная конфигурация ✅
- **Linux Desktop** - готов к работе ✅
- **Web** - PWA поддержка ✅

---

## 🎯 Быстрый старт

### Вариант 1: Автоматическая установка (Рекомендуется)

```bash
# 1. Запустить установку
./setup_arch.sh

# 2. Запустить приложение
./run.sh
```

### Вариант 2: Ручная установка

```bash
# 1. Установить зависимости
flutter pub get

# 2. Сгенерировать код
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Запустить (выберите платформу)
flutter run -d linux        # Linux Desktop
flutter run -d chrome       # Web Browser
flutter run                 # Android
```

---

## 📚 Документация

### Основные файлы:
- **[ARCH_LINUX_GUIDE.md](ARCH_LINUX_GUIDE.md)** - Полное руководство для Arch Linux
- **[README.md](README.md)** - Общая документация проекта
- **[CHANGELOG.md](CHANGELOG.md)** - История изменений
- **[QUICKSTART.md](QUICKSTART.md)** - Быстрый старт

### Полезные скрипты:
- **setup_arch.sh** - Автоматическая установка и настройка
- **run.sh** - Быстрый запуск с выбором платформы

---

## 🔍 Проверка установки

Перед запуском убедитесь, что Flutter установлен:

```bash
flutter doctor
```

Должен показать:
- ✅ Flutter (Channel stable, 3.x.x)
- ✅ Connected device

Если нет Flutter:
```bash
yay -S flutter    # или paru -S flutter
```

---

## 🎮 Запуск приложения

### Linux Desktop (Рекомендуется для Arch)
```bash
flutter run -d linux
```

### Web Browser
```bash
flutter run -d chrome --web-renderer html
```

### Android
```bash
# Запустить эмулятор или подключить устройство
flutter run
```

---

## 🧪 Тестирование

```bash
# Все тесты
flutter test

# С покрытием
flutter test --coverage

# Только unit тесты
flutter test test/unit/

# Анализ кода
flutter analyze
```

---

## 🏗️ Сборка

### Linux
```bash
flutter build linux --release
# Результат: build/linux/x64/release/bundle/
```

### Android APK
```bash
flutter build apk --release
# Результат: build/app/outputs/flutter-apk/app-release.apk
```

### Web
```bash
flutter build web --release
# Результат: build/web/
```

---

## 🐛 Решение проблем

### Проблема: task_model.g.dart не найден
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Проблема: Не работает Linux desktop
```bash
sudo pacman -S clang cmake ninja pkg-config gtk3
flutter config --enable-linux-desktop
```

### Проблема: Ошибки при pub get
```bash
flutter clean
flutter pub cache clean
flutter pub get
```

### Проблема: Flutter не найден
```bash
# Установить Flutter
yay -S flutter

# Или добавить в PATH
export PATH="$PATH:/path/to/flutter/bin"
```

---

## 📊 Статистика проекта

- **Файлов:** 50+
- **Строк кода:** ~3200
- **Зависимостей:** 13 (оптимизировано!)
- **Платформ:** Android, Linux, Web
- **Тесты:** Unit + Widget
- **Покрытие:** Domain, Data, Presentation

---

## 🎓 Полезные команды

```bash
# Проверить доступные устройства
flutter devices

# Очистить проект
flutter clean

# Обновить Flutter
flutter upgrade

# Проверить версию
flutter --version

# Форматировать код
flutter format lib/ test/

# Получить зависимости
flutter pub get

# Запустить с логами
flutter run -v
```

---

## 📖 Демонстрация оффлайн-режима

1. **Запустить с интернетом** → создать задачи
2. **Отключить интернет** (режим полета)
3. **Работать оффлайн** → создавать/редактировать задачи
4. **Включить интернет** → нажать кнопку синхронизации
5. **Готово!** Все задачи синхронизированы ✨

---

## ⚡ Особенности

- ✅ **Оффлайн-первый:** Работает без интернета
- ✅ **Автосинхронизация:** Данные синхронизируются автоматически
- ✅ **Material Design 3:** Современный UI
- ✅ **Темная тема:** Поддержка светлой и темной темы
- ✅ **Мультиязычность:** Английский и Русский
- ✅ **Clean Architecture:** Четкое разделение слоев
- ✅ **BLoC State Management:** Предсказуемое управление состоянием
- ✅ **Comprehensive Tests:** Полное тестовое покрытие

---

## 🔗 Дополнительная информация

**Проблемы?** Откройте issue на GitHub

**Вопросы?** См. [ARCH_LINUX_GUIDE.md](ARCH_LINUX_GUIDE.md)

**Обновления?** См. [CHANGELOG.md](CHANGELOG.md)

---

## 🎉 Готово!

Проект полностью готов к работе на Arch Linux!

**Начните с:**
```bash
./setup_arch.sh && ./run.sh
```

**Удачи в разработке!** 🚀

---

*Версия: 1.0.1*
*Обновлено: 18 января 2025*
*Платформа: Arch Linux ✅*
