import 'package:hive_flutter/hive_flutter.dart';
import 'package:planner_plus/data/models/task_model.dart';

/// Abstract interface for local task data source
abstract class TaskLocalDataSource {
  /// Gets all tasks from local storage
  Future<List<TaskModel>> getTasks();

  /// Gets a task by ID
  Future<TaskModel?> getTaskById(String id);

  /// Saves a task to local storage
  Future<void> saveTask(TaskModel task);

  /// Deletes a task from local storage
  Future<void> deleteTask(String id);

  /// Clears all tasks from local storage
  Future<void> clearTasks();

  /// Watches all tasks
  Stream<List<TaskModel>> watchTasks();

  /// Gets all unsynced tasks
  Future<List<TaskModel>> getUnsyncedTasks();
}

/// Implementation of TaskLocalDataSource using Hive
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  /// Creates a new TaskLocalDataSourceImpl
  TaskLocalDataSourceImpl(this._box);

  final Box<TaskModel> _box;

  /// Box name for tasks
  static const String boxName = 'tasks';

  @override
  Future<List<TaskModel>> getTasks() async {
    return _box.values.where((task) => !task.isDeleted).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    final task = _box.get(id);
    if (task != null) {
      task.isDeleted = true;
      task.isSynced = false;
      await task.save();
    }
  }

  @override
  Future<void> clearTasks() async {
    await _box.clear();
  }

  @override
  Stream<List<TaskModel>> watchTasks() {
    return _box.watch().map((_) {
      return _box.values.where((task) => !task.isDeleted).toList();
    });
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    return _box.values.where((task) => !task.isSynced).toList();
  }
}
