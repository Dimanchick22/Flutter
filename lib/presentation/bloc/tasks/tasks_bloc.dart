import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/create_task.dart';
import 'package:planner_plus/domain/usecases/delete_task.dart';
import 'package:planner_plus/domain/usecases/get_tasks.dart';
import 'package:planner_plus/domain/usecases/search_tasks.dart';
import 'package:planner_plus/domain/usecases/sync_tasks.dart';
import 'package:planner_plus/domain/usecases/update_task.dart';
import 'package:planner_plus/domain/usecases/watch_tasks.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_state.dart';

/// BLoC for managing tasks
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  /// Creates a new TasksBloc
  TasksBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.searchTasks,
    required this.syncTasks,
    required this.watchTasks,
    required this.repository,
  }) : super(const TasksInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<WatchTasksEvent>(_onWatchTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<SearchTasksEvent>(_onSearchTasks);
    on<SyncTasksEvent>(_onSyncTasks);
    on<FilterTasksEvent>(_onFilterTasks);
    on<SortTasksEvent>(_onSortTasks);
    on<GroupTasksEvent>(_onGroupTasks);

    // Start watching connectivity
    _connectivitySubscription = repository.watchConnectivity().listen((isOnline) {
      if (state is TasksLoaded) {
        emit((state as TasksLoaded).copyWith(isOnline: isOnline));
      }
    });
  }

  /// Get tasks use case
  final GetTasks getTasks;

  /// Create task use case
  final CreateTask createTask;

  /// Update task use case
  final UpdateTask updateTask;

  /// Delete task use case
  final DeleteTask deleteTask;

  /// Search tasks use case
  final SearchTasks searchTasks;

  /// Sync tasks use case
  final SyncTasks syncTasks;

  /// Watch tasks use case
  final WatchTasks watchTasks;

  /// Task repository
  final TaskRepository repository;

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<List<dynamic>>? _tasksSubscription;

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    try {
      final tasks = await getTasks();
      final isOnline = await repository.isOnline();
      emit(TasksLoaded(tasks: tasks, isOnline: isOnline));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onWatchTasks(
    WatchTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    await _tasksSubscription?.cancel();
    _tasksSubscription = watchTasks().listen((tasks) {
      if (state is TasksLoaded) {
        emit((state as TasksLoaded).copyWith(tasks: tasks));
      } else {
        repository.isOnline().then((isOnline) {
          emit(TasksLoaded(tasks: tasks, isOnline: isOnline));
        });
      }
    });
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await createTask(event.task);
      // Task list will be updated via stream
    } catch (e) {
      emit(TasksError(e.toString()));
      if (state is TasksLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await updateTask(event.task);
      // Task list will be updated via stream
    } catch (e) {
      emit(TasksError(e.toString()));
      if (state is TasksLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await deleteTask(event.taskId);
      // Task list will be updated via stream
    } catch (e) {
      emit(TasksError(e.toString()));
      if (state is TasksLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
      );
      await updateTask(updatedTask);
    } catch (e) {
      emit(TasksError(e.toString()));
      if (state is TasksLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    try {
      final tasks = await searchTasks(event.query);
      emit((state as TasksLoaded).copyWith(tasks: tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onSyncTasks(
    SyncTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    if (state is! TasksLoaded) return;

    final currentState = state as TasksLoaded;
    emit(currentState.copyWith(isSyncing: true));

    try {
      final result = await syncTasks();
      if (result.success) {
        emit(currentState.copyWith(isSyncing: false));
        emit(TasksSyncCompleted(result.syncedCount));
        emit(currentState.copyWith(isSyncing: false));
      } else {
        emit(currentState.copyWith(isSyncing: false));
        emit(TasksError(result.error?.message ?? 'Sync failed'));
        emit(currentState);
      }
    } catch (e) {
      emit(currentState.copyWith(isSyncing: false));
      emit(TasksError(e.toString()));
      emit(currentState);
    }
  }

  void _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TasksState> emit,
  ) {
    if (state is TasksLoaded) {
      emit((state as TasksLoaded).copyWith(filter: event.filter));
    }
  }

  void _onSortTasks(
    SortTasksEvent event,
    Emitter<TasksState> emit,
  ) {
    if (state is TasksLoaded) {
      emit((state as TasksLoaded).copyWith(sortBy: event.sortBy));
    }
  }

  void _onGroupTasks(
    GroupTasksEvent event,
    Emitter<TasksState> emit,
  ) {
    if (state is TasksLoaded) {
      emit((state as TasksLoaded).copyWith(groupBy: event.groupBy));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _tasksSubscription?.cancel();
    return super.close();
  }
}
