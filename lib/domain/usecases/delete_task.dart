import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/usecase.dart';

/// Use case for deleting a task
class DeleteTask extends UseCase<void, String> {
  /// Creates a new DeleteTask use case
  const DeleteTask(this.repository);

  /// Task repository
  final TaskRepository repository;

  @override
  Future<void> call(String taskId) async {
    return repository.deleteTask(taskId);
  }
}
