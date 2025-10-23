import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/usecase.dart';

/// Use case for getting all tasks
class GetTasks extends NoParamsUseCase<List<Task>> {
  /// Creates a new GetTasks use case
  const GetTasks(this.repository);

  /// Task repository
  final TaskRepository repository;

  @override
  Future<List<Task>> call() async {
    return repository.getTasks();
  }
}
