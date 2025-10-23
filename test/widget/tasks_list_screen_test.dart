import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_state.dart';
import 'package:planner_plus/presentation/screens/tasks_list_screen.dart';

class MockTasksBloc extends Mock implements TasksBloc {}

void main() {
  late MockTasksBloc mockTasksBloc;

  setUp(() {
    mockTasksBloc = MockTasksBloc();
  });

  setUpAll(() {
    registerFallbackValue(const WatchTasksEvent());
    registerFallbackValue(const FilterTasksEvent(TaskFilter.all));
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TasksBloc>(
        create: (_) => mockTasksBloc,
        child: const TasksListScreen(),
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    // arrange
    when(() => mockTasksBloc.state).thenReturn(const TasksLoading());
    when(() => mockTasksBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTasksBloc.add(any())).thenReturn(null);

    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show task list when state is loaded', (tester) async {
    // arrange
    final tasks = [
      const Task(
        id: '1',
        title: 'Test Task',
        priority: Priority.high,
      ),
    ];
    when(() => mockTasksBloc.state).thenReturn(TasksLoaded(tasks: tasks));
    when(() => mockTasksBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTasksBloc.add(any())).thenReturn(null);

    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.text('Test Task'), findsOneWidget);
  });

  testWidgets('should show empty state when no tasks', (tester) async {
    // arrange
    when(() => mockTasksBloc.state).thenReturn(const TasksLoaded(tasks: []));
    when(() => mockTasksBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTasksBloc.add(any())).thenReturn(null);

    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.text('Create your first task'), findsOneWidget);
  });
}
