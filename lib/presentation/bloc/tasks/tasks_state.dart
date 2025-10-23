import 'package:equatable/equatable.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';

/// Base class for all task states
abstract class TasksState extends Equatable {
  /// Creates a new TasksState
  const TasksState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TasksInitial extends TasksState {
  /// Creates a new TasksInitial
  const TasksInitial();
}

/// Loading state
class TasksLoading extends TasksState {
  /// Creates a new TasksLoading
  const TasksLoading();
}

/// Loaded state with tasks
class TasksLoaded extends TasksState {
  /// Creates a new TasksLoaded
  const TasksLoaded({
    required this.tasks,
    this.filter = TaskFilter.all,
    this.sortBy = TaskSortBy.date,
    this.groupBy = TaskGroupBy.none,
    this.isOnline = false,
    this.isSyncing = false,
  });

  /// List of tasks
  final List<Task> tasks;

  /// Current filter
  final TaskFilter filter;

  /// Current sort option
  final TaskSortBy sortBy;

  /// Current grouping option
  final TaskGroupBy groupBy;

  /// Online status
  final bool isOnline;

  /// Syncing status
  final bool isSyncing;

  /// Returns filtered and sorted tasks
  List<Task> get displayedTasks {
    var filtered = tasks;

    // Apply filter
    switch (filter) {
      case TaskFilter.completed:
        filtered = filtered.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        filtered = filtered.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
        break;
    }

    // Apply sort
    switch (sortBy) {
      case TaskSortBy.title:
        filtered.sort((a, b) => a.title.compareTo(b.title));
      case TaskSortBy.priority:
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      case TaskSortBy.date:
        filtered.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.now();
          final bDate = b.createdAt ?? DateTime.now();
          return bDate.compareTo(aDate);
        });
    }

    return filtered;
  }

  /// Returns grouped tasks
  Map<String, List<Task>> get groupedTasks {
    final displayed = displayedTasks;

    switch (groupBy) {
      case TaskGroupBy.priority:
        return {
          'High': displayed.where((t) => t.priority == Priority.high).toList(),
          'Medium':
              displayed.where((t) => t.priority == Priority.medium).toList(),
          'Low': displayed.where((t) => t.priority == Priority.low).toList(),
        };
      case TaskGroupBy.status:
        return {
          'Completed': displayed.where((t) => t.isCompleted).toList(),
          'Pending': displayed.where((t) => !t.isCompleted).toList(),
        };
      case TaskGroupBy.date:
        final now = DateTime.now();
        return {
          'Overdue': displayed.where((t) {
            if (t.dueDate == null) return false;
            return t.dueDate!.isBefore(now) && !t.isCompleted;
          }).toList(),
          'Today': displayed.where((t) {
            if (t.dueDate == null) return false;
            return t.dueDate!.year == now.year &&
                t.dueDate!.month == now.month &&
                t.dueDate!.day == now.day;
          }).toList(),
          'Upcoming': displayed.where((t) {
            if (t.dueDate == null) return false;
            return t.dueDate!.isAfter(now) &&
                (t.dueDate!.difference(now).inDays > 0);
          }).toList(),
          'No Due Date': displayed.where((t) => t.dueDate == null).toList(),
        };
      case TaskGroupBy.none:
        return {'All': displayed};
    }
  }

  /// Creates a copy with updated fields
  TasksLoaded copyWith({
    List<Task>? tasks,
    TaskFilter? filter,
    TaskSortBy? sortBy,
    TaskGroupBy? groupBy,
    bool? isOnline,
    bool? isSyncing,
  }) {
    return TasksLoaded(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      sortBy: sortBy ?? this.sortBy,
      groupBy: groupBy ?? this.groupBy,
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  @override
  List<Object?> get props =>
      [tasks, filter, sortBy, groupBy, isOnline, isSyncing];
}

/// Error state
class TasksError extends TasksState {
  /// Creates a new TasksError
  const TasksError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Sync completed state
class TasksSyncCompleted extends TasksState {
  /// Creates a new TasksSyncCompleted
  const TasksSyncCompleted(this.syncedCount);

  /// Number of synced tasks
  final int syncedCount;

  @override
  List<Object?> get props => [syncedCount];
}
