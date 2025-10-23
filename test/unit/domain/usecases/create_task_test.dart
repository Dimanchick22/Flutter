import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/create_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late CreateTask usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = CreateTask(mockRepository);
  });

  const tTask = Task(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    priority: Priority.high,
  );

  test('should create task in repository', () async {
    // arrange
    when(() => mockRepository.createTask(tTask))
        .thenAnswer((_) async => Future.value());

    // act
    await usecase(tTask);

    // assert
    verify(() => mockRepository.createTask(tTask)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
