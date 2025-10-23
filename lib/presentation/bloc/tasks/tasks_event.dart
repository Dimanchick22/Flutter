import 'package:equatable/equatable.dart';
import 'package:planner_plus/domain/entities/task.dart';

/// Base class for all task events
abstract class TasksEvent extends Equatable {
  /// Creates a new TasksEvent
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tasks
class LoadTasksEvent extends TasksEvent {
  /// Creates a new LoadTasksEvent
  const LoadTasksEvent();
}

/// Event to watch tasks stream
class WatchTasksEvent extends TasksEvent {
  /// Creates a new WatchTasksEvent
  const WatchTasksEvent();
}

/// Event to create a new task
class CreateTaskEvent extends TasksEvent {
  /// Creates a new CreateTaskEvent
  const CreateTaskEvent(this.task);

  /// The task to create
  final Task task;

  @override
  List<Object?> get props => [task];
}

/// Event to update a task
class UpdateTaskEvent extends TasksEvent {
  /// Creates a new UpdateTaskEvent
  const UpdateTaskEvent(this.task);

  /// The task to update
  final Task task;

  @override
  List<Object?> get props => [task];
}

/// Event to delete a task
class DeleteTaskEvent extends TasksEvent {
  /// Creates a new DeleteTaskEvent
  const DeleteTaskEvent(this.taskId);

  /// ID of the task to delete
  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

/// Event to toggle task completion
class ToggleTaskCompletionEvent extends TasksEvent {
  /// Creates a new ToggleTaskCompletionEvent
  const ToggleTaskCompletionEvent(this.task);

  /// The task to toggle
  final Task task;

  @override
  List<Object?> get props => [task];
}

/// Event to search tasks
class SearchTasksEvent extends TasksEvent {
  /// Creates a new SearchTasksEvent
  const SearchTasksEvent(this.query);

  /// Search query
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to sync tasks
class SyncTasksEvent extends TasksEvent {
  /// Creates a new SyncTasksEvent
  const SyncTasksEvent();
}

/// Event to filter tasks
class FilterTasksEvent extends TasksEvent {
  /// Creates a new FilterTasksEvent
  const FilterTasksEvent(this.filter);

  /// Filter type
  final TaskFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// Event to sort tasks
class SortTasksEvent extends TasksEvent {
  /// Creates a new SortTasksEvent
  const SortTasksEvent(this.sortBy);

  /// Sort type
  final TaskSortBy sortBy;

  @override
  List<Object?> get props => [sortBy];
}

/// Event to group tasks
class GroupTasksEvent extends TasksEvent {
  /// Creates a new GroupTasksEvent
  const GroupTasksEvent(this.groupBy);

  /// Group type
  final TaskGroupBy groupBy;

  @override
  List<Object?> get props => [groupBy];
}

/// Task filter options
enum TaskFilter {
  /// Show all tasks
  all,

  /// Show only completed tasks
  completed,

  /// Show only pending tasks
  pending,
}

/// Task sort options
enum TaskSortBy {
  /// Sort by creation date
  date,

  /// Sort by title
  title,

  /// Sort by priority
  priority,
}

/// Task grouping options
enum TaskGroupBy {
  /// No grouping
  none,

  /// Group by priority
  priority,

  /// Group by status
  status,

  /// Group by date
  date,
}
