import 'package:hive/hive.dart';
import 'package:planner_plus/domain/entities/task.dart';

part 'task_model.g.dart';

/// Hive model for Task entity
@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  /// Creates a new task model
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.tags,
    this.dueDate,
    required this.isCompleted,
    this.createdAt,
    this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  /// Creates a TaskModel from a Task entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority.index,
      tags: task.tags,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      isSynced: task.isSynced,
      isDeleted: task.isDeleted,
    );
  }

  /// Creates a TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: json['priority'] as int? ?? 1,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isSynced: json['isSynced'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  /// Unique identifier
  @HiveField(0)
  String id;

  /// Task title
  @HiveField(1)
  String title;

  /// Task description
  @HiveField(2)
  String? description;

  /// Priority (0: low, 1: medium, 2: high)
  @HiveField(3)
  int priority;

  /// Tags
  @HiveField(4)
  List<String> tags;

  /// Due date
  @HiveField(5)
  DateTime? dueDate;

  /// Completion status
  @HiveField(6)
  bool isCompleted;

  /// Creation timestamp
  @HiveField(7)
  DateTime? createdAt;

  /// Last update timestamp
  @HiveField(8)
  DateTime? updatedAt;

  /// Sync status
  @HiveField(9)
  bool isSynced;

  /// Deletion flag
  @HiveField(10)
  bool isDeleted;

  /// Converts this model to a Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: Priority.values[priority],
      tags: tags,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'tags': tags,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
      'isDeleted': isDeleted,
    };
  }
}
