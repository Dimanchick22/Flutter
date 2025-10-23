import 'package:planner_plus/core/errors/failures.dart';
import 'package:planner_plus/domain/entities/task.dart';

/// Repository interface for task operations
abstract class TaskRepository {
  /// Gets all tasks from local storage
  Future<List<Task>> getTasks();

  /// Gets a single task by ID
  Future<Task?> getTaskById(String id);

  /// Creates a new task
  Future<void> createTask(Task task);

  /// Updates an existing task
  Future<void> updateTask(Task task);

  /// Deletes a task
  Future<void> deleteTask(String id);

  /// Searches tasks by query
  Future<List<Task>> searchTasks(String query);

  /// Synchronizes local tasks with remote server
  Future<SyncResult> syncTasks();

  /// Stream of all tasks
  Stream<List<Task>> watchTasks();

  /// Checks if device is online
  Future<bool> isOnline();

  /// Stream of connectivity status
  Stream<bool> watchConnectivity();
}

/// Result of a synchronization operation
class SyncResult {
  /// Creates a new sync result
  const SyncResult({
    required this.success,
    this.error,
    this.syncedCount = 0,
  });

  /// Whether the sync was successful
  final bool success;

  /// Error message if sync failed
  final Failure? error;

  /// Number of tasks synchronized
  final int syncedCount;
}
