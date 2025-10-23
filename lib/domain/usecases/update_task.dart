import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/usecase.dart';

/// Use case for updating an existing task
class UpdateTask extends UseCase<void, Task> {
  /// Creates a new UpdateTask use case
  const UpdateTask(this.repository);

  /// Task repository
  final TaskRepository repository;

  @override
  Future<void> call(Task task) async {
    return repository.updateTask(task);
  }
}
