import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/usecase.dart';

/// Use case for creating a new task
class CreateTask extends UseCase<void, Task> {
  /// Creates a new CreateTask use case
  const CreateTask(this.repository);

  /// Task repository
  final TaskRepository repository;

  @override
  Future<void> call(Task task) async {
    return repository.createTask(task);
  }
}
