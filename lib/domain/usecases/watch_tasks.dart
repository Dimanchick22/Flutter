import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';

/// Use case for watching tasks stream
class WatchTasks {
  /// Creates a new WatchTasks use case
  const WatchTasks(this.repository);

  /// Task repository
  final TaskRepository repository;

  /// Returns a stream of all tasks
  Stream<List<Task>> call() {
    return repository.watchTasks();
  }
}
