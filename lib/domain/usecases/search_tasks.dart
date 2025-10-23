import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/usecase.dart';

/// Use case for searching tasks
class SearchTasks extends UseCase<List<Task>, String> {
  /// Creates a new SearchTasks use case
  const SearchTasks(this.repository);

  /// Task repository
  final TaskRepository repository;

  @override
  Future<List<Task>> call(String query) async {
    return repository.searchTasks(query);
  }
}
