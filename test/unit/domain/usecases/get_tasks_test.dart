import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/domain/repositories/task_repository.dart';
import 'package:planner_plus/domain/usecases/get_tasks.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late GetTasks usecase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    usecase = GetTasks(mockRepository);
  });

  final tTasks = [
    const Task(
      id: '1',
      title: 'Test Task 1',
      priority: Priority.high,
    ),
    const Task(
      id: '2',
      title: 'Test Task 2',
      priority: Priority.medium,
    ),
  ];

  test('should get all tasks from repository', () async {
    // arrange
    when(() => mockRepository.getTasks()).thenAnswer((_) async => tTasks);

    // act
    final result = await usecase();

    // assert
    expect(result, tTasks);
    verify(() => mockRepository.getTasks()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
