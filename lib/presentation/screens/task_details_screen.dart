import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_state.dart';
import 'package:uuid/uuid.dart';

/// Task details screen for creating or editing a task
class TaskDetailsScreen extends StatefulWidget {
  /// Creates a new TaskDetailsScreen
  const TaskDetailsScreen({
    this.taskId,
    super.key,
  });

  /// Task ID for editing, null for creating new task
  final String? taskId;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();

  Priority _selectedPriority = Priority.medium;
  DateTime? _selectedDueDate;
  List<String> _tags = [];
  bool _isCompleted = false;
  Task? _originalTask;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTask();
    }
  }

  void _loadTask() {
    final state = context.read<TasksBloc>().state;
    if (state is TasksLoaded) {
      _originalTask = state.tasks.firstWhere(
        (task) => task.id == widget.taskId,
      );
      _titleController.text = _originalTask!.title;
      _descriptionController.text = _originalTask!.description ?? '';
      _selectedPriority = _originalTask!.priority;
      _selectedDueDate = _originalTask!.dueDate;
      _tags = List.from(_originalTask!.tags);
      _isCompleted = _originalTask!.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: widget.taskId ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      priority: _selectedPriority,
      tags: _tags,
      dueDate: _selectedDueDate,
      isCompleted: _isCompleted,
      createdAt: _originalTask?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    if (widget.taskId == null) {
      context.read<TasksBloc>().add(CreateTaskEvent(task));
    } else {
      context.read<TasksBloc>().add(UpdateTaskEvent(task));
    }

    context.pop();
  }

  void _deleteTask() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TasksBloc>().add(DeleteTaskEvent(widget.taskId!));
              Navigator.of(context).pop();
              context.pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.taskId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete task',
              onPressed: _deleteTask,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Task title is required';
                }
                return null;
              },
              autofocus: !isEditing,
            ),
            const SizedBox(height: 16),
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Priority
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<Priority>(
                      segments: const [
                        ButtonSegment(
                          value: Priority.low,
                          label: Text('Low'),
                          icon: Icon(Icons.flag, color: Colors.green),
                        ),
                        ButtonSegment(
                          value: Priority.medium,
                          label: Text('Medium'),
                          icon: Icon(Icons.flag, color: Colors.orange),
                        ),
                        ButtonSegment(
                          value: Priority.high,
                          label: Text('High'),
                          icon: Icon(Icons.flag, color: Colors.red),
                        ),
                      ],
                      selected: {_selectedPriority},
                      onSelectionChanged: (Set<Priority> selected) {
                        setState(() => _selectedPriority = selected.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Due Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: _selectedDueDate != null
                    ? Text(DateFormat.yMMMMd().format(_selectedDueDate!))
                    : const Text('No due date'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedDueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _selectedDueDate = null),
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _selectDueDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tags
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: 'Add a tag',
                              prefixIcon: Icon(Icons.label),
                            ),
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTag,
                        ),
                      ],
                    ),
                    if (_tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                onDeleted: () => _removeTag(tag),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Completed checkbox
            if (isEditing)
              Card(
                child: SwitchListTile(
                  value: _isCompleted,
                  onChanged: (value) => setState(() => _isCompleted = value),
                  title: const Text('Completed'),
                  secondary: const Icon(Icons.check_circle),
                ),
              ),
            const SizedBox(height: 24),
            // Save button
            FilledButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Update Task' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
