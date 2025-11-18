import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:planner_plus/core/errors/exceptions.dart';
import 'package:planner_plus/core/errors/failures.dart';
import 'package:planner_plus/data/datasources/task_local_datasource.dart';
import 'package:planner_plus/data/datasources/task_remote_datasource.dart';
import 'package:planner_plus/data/models/task_model.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository
class TaskRepositoryImpl implements TaskRepository {
  /// Creates a new TaskRepositoryImpl
  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.connectivity,
  });

  /// Local data source for tasks
  final TaskLocalDataSource localDataSource;

  /// Remote data source for tasks
  final TaskRemoteDataSource remoteDataSource;

  /// Connectivity plugin
  final Connectivity connectivity;

  @override
  Future<List<Task>> getTasks() async {
    try {
      final tasks = await localDataSource.getTasks();
      return tasks.map((model) => model.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      final task = await localDataSource.getTaskById(id);
      return task?.toEntity();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> createTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      ));
      await localDataSource.saveTask(model);

      // Try to sync immediately if online
      if (await isOnline()) {
        try {
          await remoteDataSource.createTask(model);
          model.isSynced = true;
          await localDataSource.saveTask(model);
        } catch (_) {
          // Ignore sync errors, will sync later
        }
      }
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final model = TaskModel.fromEntity(task.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      ));
      await localDataSource.saveTask(model);

      // Try to sync immediately if online
      if (await isOnline()) {
        try {
          await remoteDataSource.updateTask(model);
          model.isSynced = true;
          await localDataSource.saveTask(model);
        } catch (_) {
          // Ignore sync errors, will sync later
        }
      }
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);

      // Try to sync immediately if online
      if (await isOnline()) {
        try {
          await remoteDataSource.deleteTask(id);
        } catch (_) {
          // Ignore sync errors, will sync later
        }
      }
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    try {
      final tasks = await localDataSource.getTasks();
      final filtered = tasks.where((task) {
        final titleMatch =
            task.title.toLowerCase().contains(query.toLowerCase());
        final descriptionMatch = task.description
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
        final tagsMatch =
            task.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        return titleMatch || descriptionMatch || tagsMatch;
      }).toList();
      return filtered.map((model) => model.toEntity()).toList();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<SyncResult> syncTasks() async {
    try {
      // Check if online
      if (!await isOnline()) {
        return const SyncResult(
          success: false,
          error: NetworkFailure('No internet connection'),
        );
      }

      // Get unsynced tasks
      final unsyncedTasks = await localDataSource.getUnsyncedTasks();

      if (unsyncedTasks.isEmpty) {
        return const SyncResult(success: true, syncedCount: 0);
      }

      // Sync with remote
      try {
        final syncedTasks = await remoteDataSource.syncTasks(unsyncedTasks);

        // Update local storage
        for (final task in syncedTasks) {
          await localDataSource.saveTask(task);
        }

        return SyncResult(
          success: true,
          syncedCount: syncedTasks.length,
        );
      } on ServerException catch (e) {
        return SyncResult(
          success: false,
          error: ServerFailure(e.message),
        );
      }
    } catch (e) {
      return SyncResult(
        success: false,
        error: CacheFailure(e.toString()),
      );
    }
  }

  @override
  Stream<List<Task>> watchTasks() {
    return localDataSource.watchTasks().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<bool> isOnline() async {
    final result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }

  @override
  Stream<bool> watchConnectivity() {
    return connectivity.onConnectivityChanged.map((result) {
      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    });
  }
}
