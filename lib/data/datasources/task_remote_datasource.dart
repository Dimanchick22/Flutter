import 'package:dio/dio.dart';
import 'package:planner_plus/core/errors/exceptions.dart';
import 'package:planner_plus/data/models/task_model.dart';

/// Abstract interface for remote task data source
abstract class TaskRemoteDataSource {
  /// Fetches all tasks from the server
  Future<List<TaskModel>> getTasks();

  /// Fetches a task by ID from the server
  Future<TaskModel> getTaskById(String id);

  /// Creates a new task on the server
  Future<TaskModel> createTask(TaskModel task);

  /// Updates a task on the server
  Future<TaskModel> updateTask(TaskModel task);

  /// Deletes a task on the server
  Future<void> deleteTask(String id);

  /// Syncs local changes with the server
  Future<List<TaskModel>> syncTasks(List<TaskModel> localTasks);
}

/// Implementation of TaskRemoteDataSource using Dio
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  /// Creates a new TaskRemoteDataSourceImpl
  TaskRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Base URL for the API (JSONPlaceholder as a mock API)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get<List<dynamic>>('$baseUrl/todos');

      if (response.statusCode == 200 && response.data != null) {
        // Convert JSONPlaceholder todos to our TaskModel format
        return response.data!.take(20).map((json) {
          final data = json as Map<String, dynamic>;
          return TaskModel(
            id: data['id'].toString(),
            title: data['title'] as String,
            description: null,
            priority: 1, // medium
            tags: [],
            isCompleted: data['completed'] as bool? ?? false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: true,
            isDeleted: false,
          );
        }).toList();
      }

      throw ServerException('Failed to fetch tasks');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('$baseUrl/todos/$id');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        return TaskModel(
          id: data['id'].toString(),
          title: data['title'] as String,
          description: null,
          priority: 1,
          tags: [],
          isCompleted: data['completed'] as bool? ?? false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: true,
          isDeleted: false,
        );
      }

      throw ServerException('Failed to fetch task');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$baseUrl/todos',
        data: {
          'title': task.title,
          'completed': task.isCompleted,
          'userId': 1,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        // Return the task with synced flag
        task.isSynced = true;
        return task;
      }

      throw ServerException('Failed to create task');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '$baseUrl/todos/${task.id}',
        data: {
          'title': task.title,
          'completed': task.isCompleted,
          'userId': 1,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        task.isSynced = true;
        return task;
      }

      throw ServerException('Failed to update task');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete<void>('$baseUrl/todos/$id');

      if (response.statusCode != 200) {
        throw ServerException('Failed to delete task');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<TaskModel>> syncTasks(List<TaskModel> localTasks) async {
    final syncedTasks = <TaskModel>[];

    for (final task in localTasks) {
      try {
        if (task.isDeleted) {
          await deleteTask(task.id);
        } else if (task.createdAt == task.updatedAt) {
          // New task
          final synced = await createTask(task);
          syncedTasks.add(synced);
        } else {
          // Updated task
          final synced = await updateTask(task);
          syncedTasks.add(synced);
        }
      } catch (e) {
        // Continue syncing other tasks even if one fails
        continue;
      }
    }

    return syncedTasks;
  }

  ServerException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ServerException('Connection timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      return ServerException('No internet connection');
    } else if (e.response?.statusCode == 404) {
      return ServerException('Resource not found');
    } else if (e.response?.statusCode == 500) {
      return ServerException('Server error');
    }
    return ServerException('Unknown error occurred');
  }
}
