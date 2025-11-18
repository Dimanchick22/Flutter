import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/usecase.dart';

/// Use case for synchronizing tasks with remote server
class SyncTasks extends NoParamsUseCase<SyncResult> {
  /// Creates a new SyncTasks use case
  SyncTasks(this.repository);

  /// Task repository
  final TaskRepository repository;

  @override
  Future<SyncResult> call() async {
    return repository.syncTasks();
  }
}
