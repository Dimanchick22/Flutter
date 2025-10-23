import 'package:equatable/equatable.dart';

/// Represents the priority level of a task
enum Priority {
  /// Low priority task
  low,

  /// Medium priority task
  medium,

  /// High priority task
  high,
}

/// Task entity representing a single task in the planner
class Task extends Equatable {
  /// Creates a new task entity
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.priority = Priority.medium,
    this.tags = const [],
    this.dueDate,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  /// Unique identifier for the task
  final String id;

  /// Title of the task
  final String title;

  /// Optional description of the task
  final String? description;

  /// Priority level of the task
  final Priority priority;

  /// List of tags associated with the task
  final List<String> tags;

  /// Optional due date for the task
  final DateTime? dueDate;

  /// Whether the task is completed
  final bool isCompleted;

  /// When the task was created
  final DateTime? createdAt;

  /// When the task was last updated
  final DateTime? updatedAt;

  /// Whether the task has been synced with the server
  final bool isSynced;

  /// Whether the task is marked for deletion
  final bool isDeleted;

  /// Creates a copy of this task with the given fields replaced with new values
  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    List<String>? tags,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        tags,
        dueDate,
        isCompleted,
        createdAt,
        updatedAt,
        isSynced,
        isDeleted,
      ];
}
