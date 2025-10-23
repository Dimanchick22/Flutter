import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_state.dart';
import 'package:planner_plus/presentation/widgets/task_list_item.dart';

/// Tasks list screen
class TasksListScreen extends StatefulWidget {
  /// Creates a new TasksListScreen
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(const WatchTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner+'),
        actions: [
          // Connectivity status
          BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              if (state is TasksLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Icon(
                      state.isOnline
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      color: state.isOnline ? Colors.green : Colors.grey,
                      semanticLabel: state.isOnline ? 'Online' : 'Offline',
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Sync button
          BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              if (state is TasksLoaded && state.isOnline) {
                return IconButton(
                  icon: state.isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  tooltip: 'Sync tasks',
                  onPressed: state.isSyncing
                      ? null
                      : () => context.read<TasksBloc>().add(const SyncTasksEvent()),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => context.push('/search'),
          ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: BlocConsumer<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is TasksSyncCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Synced ${state.syncedCount} tasks'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksLoaded) {
            return Column(
              children: [
                // Filters and controls
                _buildControls(context, state),
                // Task list
                Expanded(child: _buildTaskList(context, state)),
              ],
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/task/new'),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildControls(BuildContext context, TasksLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Filter
            SegmentedButton<TaskFilter>(
              segments: const [
                ButtonSegment(
                  value: TaskFilter.all,
                  label: Text('All'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment(
                  value: TaskFilter.pending,
                  label: Text('Pending'),
                  icon: Icon(Icons.pending),
                ),
                ButtonSegment(
                  value: TaskFilter.completed,
                  label: Text('Completed'),
                  icon: Icon(Icons.check_circle),
                ),
              ],
              selected: {state.filter},
              onSelectionChanged: (Set<TaskFilter> selected) {
                context.read<TasksBloc>().add(FilterTasksEvent(selected.first));
              },
            ),
            const SizedBox(width: 8),
            // Sort
            PopupMenuButton<TaskSortBy>(
              icon: const Icon(Icons.sort),
              tooltip: 'Sort',
              onSelected: (sortBy) {
                context.read<TasksBloc>().add(SortTasksEvent(sortBy));
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: TaskSortBy.date,
                  child: Text('By Date'),
                ),
                const PopupMenuItem(
                  value: TaskSortBy.title,
                  child: Text('By Title'),
                ),
                const PopupMenuItem(
                  value: TaskSortBy.priority,
                  child: Text('By Priority'),
                ),
              ],
            ),
            // Group
            PopupMenuButton<TaskGroupBy>(
              icon: const Icon(Icons.group_work),
              tooltip: 'Group',
              onSelected: (groupBy) {
                context.read<TasksBloc>().add(GroupTasksEvent(groupBy));
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: TaskGroupBy.none,
                  child: Text('No Grouping'),
                ),
                const PopupMenuItem(
                  value: TaskGroupBy.priority,
                  child: Text('By Priority'),
                ),
                const PopupMenuItem(
                  value: TaskGroupBy.status,
                  child: Text('By Status'),
                ),
                const PopupMenuItem(
                  value: TaskGroupBy.date,
                  child: Text('By Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, TasksLoaded state) {
    final groupedTasks = state.groupedTasks;
    final hasNoTasks = state.tasks.isEmpty;

    if (hasNoTasks) {
      return _buildEmptyState(context);
    }

    if (state.groupBy == TaskGroupBy.none) {
      final tasks = groupedTasks['All'] ?? [];
      if (tasks.isEmpty) {
        return _buildNoResultsState(context);
      }
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskListItem(
            task: tasks[index],
            onTap: () => context.push('/task/${tasks[index].id}'),
            onToggle: (task) => context
                .read<TasksBloc>()
                .add(ToggleTaskCompletionEvent(task)),
          );
        },
      );
    }

    // Grouped view
    return ListView.builder(
      itemCount: groupedTasks.length,
      itemBuilder: (context, index) {
        final group = groupedTasks.keys.elementAt(index);
        final tasks = groupedTasks[group] ?? [];

        if (tasks.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                group,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            ...tasks.map((task) => TaskListItem(
                  task: task,
                  onTap: () => context.push('/task/${task.id}'),
                  onToggle: (task) => context
                      .read<TasksBloc>()
                      .add(ToggleTaskCompletionEvent(task)),
                )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
