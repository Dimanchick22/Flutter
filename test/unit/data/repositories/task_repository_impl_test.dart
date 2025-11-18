import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planner_plus/data/datasources/task_local_datasource.dart';
import 'package:planner_plus/data/datasources/task_remote_datasource.dart';
import 'package:planner_plus/data/models/task_model.dart';
import 'package:planner_plus/data/repositories/task_repository_impl.dart';
import 'package:planner_plus/domain/entities/task.dart';

class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late TaskRepositoryImpl repository;
  late MockTaskLocalDataSource mockLocalDataSource;
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockLocalDataSource = MockTaskLocalDataSource();
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockConnectivity = MockConnectivity();
    repository = TaskRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      connectivity: mockConnectivity,
    );
  });

  group('getTasks', () {
    final tTaskModels = [
      TaskModel(
        id: '1',
        title: 'Test Task',
        priority: 1,
        tags: [],
        isCompleted: false,
        isSynced: true,
        isDeleted: false,
      ),
    ];

    test('should return list of tasks from local data source', () async {
      // arrange
      when(() => mockLocalDataSource.getTasks())
          .thenAnswer((_) async => tTaskModels);

      // act
      final result = await repository.getTasks();

      // assert
      expect(result.length, 1);
      expect(result.first.id, '1');
      expect(result.first.title, 'Test Task');
      verify(() => mockLocalDataSource.getTasks()).called(1);
    });
  });

  group('createTask', () {
    const tTask = Task(
      id: '1',
      title: 'Test Task',
      priority: Priority.medium,
    );

    test('should save task to local data source', () async {
      // arrange
      when(() => mockLocalDataSource.saveTask(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      // act
      await repository.createTask(tTask);

      // assert
      verify(() => mockLocalDataSource.saveTask(any())).called(1);
    });
  });

  group('isOnline', () {
    test('should return true when connected to wifi', () async {
      // arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);

      // act
      final result = await repository.isOnline();

      // assert
      expect(result, true);
    });

    test('should return false when not connected', () async {
      // arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      // act
      final result = await repository.isOnline();

      // assert
      expect(result, false);
    });
  });
}
