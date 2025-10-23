import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:planner_plus/core/di/injection.dart';
import 'package:planner_plus/core/router/app_router.dart';
import 'package:planner_plus/core/theme/app_theme.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/create_task.dart';
import 'package:planner_plus/domain/usecases/delete_task.dart';
import 'package:planner_plus/domain/usecases/get_tasks.dart';
import 'package:planner_plus/domain/usecases/search_tasks.dart';
import 'package:planner_plus/domain/usecases/sync_tasks.dart';
import 'package:planner_plus/domain/usecases/update_task.dart';
import 'package:planner_plus/domain/usecases/watch_tasks.dart';
import 'package:planner_plus/presentation/bloc/settings/settings_bloc.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const PlannerApp());
}

/// Main application widget
class PlannerApp extends StatelessWidget {
  /// Creates a new PlannerApp
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TasksBloc(
            getTasks: sl<GetTasks>(),
            createTask: sl<CreateTask>(),
            updateTask: sl<UpdateTask>(),
            deleteTask: sl<DeleteTask>(),
            searchTasks: sl<SearchTasks>(),
            syncTasks: sl<SyncTasks>(),
            watchTasks: sl<WatchTasks>(),
            repository: sl<TaskRepository>(),
          )..add(const WatchTasksEvent()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) =>
              SettingsBloc(sl<SharedPreferences>())..add(LoadSettingsEvent()),
          lazy: false,
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Planner+',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getThemeMode(state.themePreference),
            locale: state.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
            routerConfig: AppRouter.createRouter(),
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(ThemePreference preference) {
    return switch (preference) {
      ThemePreference.system => ThemeMode.system,
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
    };
  }
}
