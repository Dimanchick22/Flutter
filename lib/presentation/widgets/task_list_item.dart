import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_plus/domain/entities/task.dart';

/// Widget for displaying a task in the list
class TaskListItem extends StatelessWidget {
  /// Creates a new TaskListItem
  const TaskListItem({
    required this.task,
    required this.onTap,
    required this.onToggle,
    super.key,
  });

  /// The task to display
  final Task task;

  /// Callback when task is tapped
  final VoidCallback onTap;

  /// Callback when completion is toggled
  final void Function(Task task) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(task),
                semanticLabel: task.isCompleted
                    ? 'Mark as incomplete'
                    : 'Mark as complete',
              ),
              const SizedBox(width: 12),
              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? theme.colorScheme.onSurface.withOpacity(0.6)
                            : null,
                      ),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // Tags and metadata
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // Priority chip
                        _PriorityChip(priority: task.priority),
                        // Due date chip
                        if (task.dueDate != null)
                          Chip(
                            label: Text(
                              DateFormat.yMMMd().format(task.dueDate!),
                              style: theme.textTheme.bodySmall,
                            ),
                            avatar: Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: isOverdue ? Colors.red : null,
                            ),
                            backgroundColor: isOverdue
                                ? Colors.red.withOpacity(0.1)
                                : null,
                          ),
                        // Tags
                        ...task.tags.take(2).map(
                              (tag) => Chip(
                                label: Text(
                                  tag,
                                  style: theme.textTheme.bodySmall,
                                ),
                                avatar: const Icon(Icons.label, size: 16),
                              ),
                            ),
                        if (task.tags.length > 2)
                          Chip(
                            label: Text(
                              '+${task.tags.length - 2}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        // Sync status
                        if (!task.isSynced)
                          Chip(
                            label: Text(
                              'Not synced',
                              style: theme.textTheme.bodySmall,
                            ),
                            avatar: const Icon(Icons.cloud_off, size: 16),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (priority) {
      Priority.high => Colors.red,
      Priority.medium => Colors.orange,
      Priority.low => Colors.green,
    };

    final label = switch (priority) {
      Priority.high => 'High',
      Priority.medium => 'Medium',
      Priority.low => 'Low',
    };

    return Chip(
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      avatar: Icon(
        Icons.flag,
        size: 16,
        color: color,
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
