# 🔧 ИСПРАВЛЕНО! Инструкция по запуску

## ✅ Проблема решена!

Основная проблема была в несовместимости версий пакетов. Исправлено:

### Что было сделано:
1. **intl: ^0.19.0 → ^0.20.2** (обязательное требование Flutter SDK)
2. Удален неиспользуемый пакет `retry`
3. Понижены версии некоторых пакетов для совместимости
4. SDK requirement: 3.5.0 → 3.0.0 (поддержка Arch AUR Flutter)

---

## 🚀 Запуск (после git pull)

### Шаг 1: Обновить код
```bash
git pull origin claude/planner-plus-app-011CUPnsLBq25YvYFF47zGLh
```

### Шаг 2: Очистить и установить
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Шаг 3: Запустить приложение
```bash
# Вариант 1: Автоматически
./run.sh

# Вариант 2: Вручную
flutter run -d linux     # Linux Desktop
flutter run -d chrome    # Web Browser
```

---

## 📝 Полная команда (копировать и вставить)

```bash
# Обновить репозиторий
git pull origin claude/planner-plus-app-011CUPnsLBq25YvYFF47zGLh

# Установить зависимости
flutter clean && flutter pub get

# Сгенерировать код
flutter pub run build_runner build --delete-conflicting-outputs

# Запустить на Linux Desktop
flutter run -d linux
```

---

## 🎯 Если что-то не работает

### Проблема: Все еще ошибки версий
```bash
flutter pub cache clean
flutter clean
flutter pub get
```

### Проблема: task_model.g.dart не найден
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Проблема: Linux desktop не работает
```bash
sudo pacman -S clang cmake ninja pkg-config gtk3
flutter config --enable-linux-desktop
```

---

## ✨ Теперь должно работать!

После выполнения команд выше:
- ✅ Все зависимости установятся без ошибок
- ✅ Код сгенерируется корректно
- ✅ Приложение запустится на Linux

**Попробуйте сейчас:**
```bash
./setup_arch.sh
```

или

```bash
flutter clean && flutter pub get && flutter run -d linux
```

---

## 📊 Изменения в версиях

| Пакет | Было | Стало | Причина |
|-------|------|-------|---------|
| intl | ^0.19.0 | ^0.20.2 | Требование Flutter SDK |
| flutter_bloc | ^8.1.6 | ^8.1.0 | Стабильность |
| get_it | ^8.0.2 | ^7.6.0 | Совместимость |
| go_router | ^14.6.2 | ^13.0.0 | Совместимость |
| dio | ^5.7.0 | ^5.4.0 | Совместимость |
| connectivity_plus | ^6.1.1 | ^5.0.0 | Совместимость |
| retry | ^3.1.2 | удален | Не используется |
| SDK | >=3.5.0 | >=3.0.0 | Arch AUR Flutter |

---

## 🎉 Готово!

Теперь проект полностью совместим с Arch Linux Flutter!

*Версия: 1.0.2*
*Дата исправления: 18 января 2025*
