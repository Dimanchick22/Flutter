# Planner+ для Arch Linux

## Полное руководство по установке и запуску на Arch Linux

### Предварительные требования

#### 1. Установка Flutter

**Вариант 1: Через AUR (рекомендуется)**
```bash
# Используя yay
yay -S flutter

# Или используя paru
paru -S flutter
```

**Вариант 2: Ручная установка**
```bash
# Скачать Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Добавить в PATH (добавьте в ~/.bashrc или ~/.zshrc)
export PATH="$PATH:$HOME/development/flutter/bin"

# Применить изменения
source ~/.bashrc  # или source ~/.zshrc
```

#### 2. Установка зависимостей

```bash
# Основные зависимости для Flutter
sudo pacman -S git curl unzip zip xz

# Для разработки под Linux
sudo pacman -S clang cmake ninja pkg-config gtk3

# Для разработки под Android (опционально)
yay -S android-sdk android-sdk-platform-tools android-sdk-build-tools
yay -S android-studio  # или IntelliJ IDEA

# Для веб-разработки
sudo pacman -S chromium  # или google-chrome
```

#### 3. Настройка Flutter

```bash
# Проверить установку
flutter doctor

# Принять лицензии Android (если используете Android)
flutter doctor --android-licenses

# Настроить Chrome для веб-разработки
flutter config --enable-web

# Настроить Linux desktop
flutter config --enable-linux-desktop
```

### Установка Planner+

#### 1. Клонирование репозитория

```bash
git clone https://github.com/Dimanchick22/Flutter.git planner_plus
cd planner_plus
git checkout claude/planner-plus-app-011CUPnsLBq25YvYFF47zGLh
```

#### 2. Автоматическая установка

```bash
# Запустить скрипт установки
./setup_arch.sh
```

Скрипт автоматически:
- Проверит установку Flutter
- Установит зависимости (`flutter pub get`)
- Сгенерирует необходимый код
- Запустит `flutter doctor`

#### 3. Ручная установка (если скрипт не работает)

```bash
# Установить зависимости
flutter pub get

# Сгенерировать код
flutter pub run build_runner build --delete-conflicting-outputs

# Проверить проект
flutter analyze
```

### Запуск приложения

#### Вариант 1: Использовать скрипт запуска

```bash
./run.sh
```

Скрипт предложит выбрать платформу:
1. Linux Desktop
2. Web Browser
3. Android Device/Emulator

#### Вариант 2: Прямой запуск

**Linux Desktop (рекомендуется для Arch)**
```bash
flutter run -d linux
```

**Web Browser**
```bash
flutter run -d chrome --web-renderer html
```

**Android (если настроено)**
```bash
# Запустить эмулятор
flutter emulators --launch <emulator_id>

# Или подключить физическое устройство и запустить
flutter run
```

### Сборка приложения

#### Linux Desktop

```bash
# Debug build
flutter build linux

# Release build
flutter build linux --release

# Результат в: build/linux/x64/release/bundle/
```

#### Web

```bash
# Release build
flutter build web --release

# Результат в: build/web/
```

#### Android APK

```bash
# Release APK
flutter build apk --release

# Результат в: build/app/outputs/flutter-apk/app-release.apk
```

### Тестирование

```bash
# Запустить все тесты
flutter test

# С покрытием кода
flutter test --coverage

# Только unit тесты
flutter test test/unit/

# Только widget тесты
flutter test test/widget/
```

### Возможные проблемы и решения

#### Проблема: Flutter не найден

**Решение:**
```bash
# Проверить PATH
echo $PATH | grep flutter

# Если не найден, добавить в ~/.bashrc или ~/.zshrc
export PATH="$PATH:/path/to/flutter/bin"
source ~/.bashrc
```

#### Проблема: Не работает Linux desktop

**Решение:**
```bash
# Установить необходимые библиотеки
sudo pacman -S clang cmake ninja pkg-config gtk3

# Включить Linux desktop support
flutter config --enable-linux-desktop

# Проверить
flutter doctor
```

#### Проблема: Ошибки при flutter pub get

**Решение:**
```bash
# Очистить кэш
flutter clean
flutter pub cache clean

# Попробовать снова
flutter pub get
```

#### Проблема: task_model.g.dart не найден

**Решение:**
```bash
# Сгенерировать код
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Проблема: Ошибки линтера

**Решение:**
```bash
# Обновить зависимости
flutter pub upgrade

# Проверить анализ
flutter analyze

# Исправить форматирование
flutter format lib/ test/
```

### Оптимизация для Arch Linux

#### 1. Ускорение сборки

```bash
# Увеличить лимит файловых дескрипторов
ulimit -n 4096

# Использовать больше CPU для Gradle (для Android)
echo "org.gradle.daemon=true" >> android/gradle.properties
echo "org.gradle.parallel=true" >> android/gradle.properties
echo "org.gradle.workers.max=4" >> android/gradle.properties
```

#### 2. Использование ccache (для Linux builds)

```bash
# Установить ccache
sudo pacman -S ccache

# Настроить
export PATH="/usr/lib/ccache/bin:$PATH"
```

### Разработка

#### Hot Reload

При запуске с `flutter run`, изменения кода применяются автоматически:
- `r` - Hot reload
- `R` - Hot restart
- `h` - Помощь
- `q` - Выход

#### Debug Mode

```bash
# Запуск в debug режиме с логами
flutter run -v
```

#### Режим разработки с логами

```bash
# Смотреть логи
flutter logs
```

### Производительность

#### Проверка производительности

```bash
# Профилирование
flutter run --profile

# Открыть DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

#### Оптимизация размера приложения

```bash
# Сборка с минимизацией
flutter build apk --release --split-per-abi

# Проверить размер
flutter build apk --analyze-size
```

### Системные требования

**Минимальные:**
- Arch Linux (актуальная версия)
- 4 GB RAM
- 2 GB свободного места на диске
- Процессор с поддержкой 64-бит

**Рекомендуемые:**
- 8 GB RAM
- 10 GB свободного места
- SSD для ускорения сборки

### Полезные команды

```bash
# Проверить версию Flutter
flutter --version

# Обновить Flutter
flutter upgrade

# Проверить доступные устройства
flutter devices

# Очистить проект
flutter clean

# Получить информацию о пакете
flutter pub deps

# Проверить устаревшие зависимости
flutter pub outdated
```

### Конфигурация IDE

#### VS Code

```bash
# Установить VS Code
yay -S visual-studio-code-bin

# Установить расширения Flutter и Dart
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
```

#### Android Studio

```bash
# Установить Android Studio
yay -S android-studio

# После установки:
# 1. Открыть Android Studio
# 2. Configure → Plugins
# 3. Установить Flutter и Dart plugins
```

### Дополнительные ресурсы

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter на Arch Wiki](https://wiki.archlinux.org/title/Flutter)
- [Flutter GitHub](https://github.com/flutter/flutter)

### Поддержка

Если возникли проблемы:
1. Проверьте `flutter doctor`
2. Проверьте логи: `flutter logs`
3. Создайте issue в репозитории проекта

### Обновления

Для обновления проекта до последней версии:

```bash
git pull origin claude/planner-plus-app-011CUPnsLBq25YvYFF47zGLh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```
