import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planner_plus/data/datasources/task_local_datasource.dart';
import 'package:planner_plus/data/datasources/task_remote_datasource.dart';
import 'package:planner_plus/data/models/task_model.dart';
import 'package:planner_plus/data/repositories/task_repository_impl.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/create_task.dart';
import 'package:planner_plus/domain/usecases/delete_task.dart';
import 'package:planner_plus/domain/usecases/get_tasks.dart';
import 'package:planner_plus/domain/usecases/search_tasks.dart';
import 'package:planner_plus/domain/usecases/sync_tasks.dart';
import 'package:planner_plus/domain/usecases/update_task.dart';
import 'package:planner_plus/domain/usecases/watch_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initializes all dependencies
Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskModelAdapter());
  }

  // Open boxes
  final taskBox = await Hive.openBox<TaskModel>(TaskLocalDataSourceImpl.boxName);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // External dependencies
  sl
    ..registerLazySingleton(() => Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ))
    ..registerLazySingleton(() => Connectivity())
    ..registerLazySingleton(() => taskBox)
    ..registerLazySingleton(() => prefs);

  // Data sources
  sl
    ..registerLazySingleton<TaskLocalDataSource>(
      () => TaskLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(sl()),
    );

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      connectivity: sl(),
    ),
  );

  // Use cases
  sl
    ..registerLazySingleton(() => GetTasks(sl()))
    ..registerLazySingleton(() => CreateTask(sl()))
    ..registerLazySingleton(() => UpdateTask(sl()))
    ..registerLazySingleton(() => DeleteTask(sl()))
    ..registerLazySingleton(() => SearchTasks(sl()))
    ..registerLazySingleton(() => SyncTasks(sl()))
    ..registerLazySingleton(() => WatchTasks(sl()));
}
