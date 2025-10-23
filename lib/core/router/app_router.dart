import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_plus/presentation/screens/search_screen.dart';
import 'package:planner_plus/presentation/screens/settings_screen.dart';
import 'package:planner_plus/presentation/screens/task_details_screen.dart';
import 'package:planner_plus/presentation/screens/tasks_list_screen.dart';

/// Application router configuration
class AppRouter {
  /// Creates the GoRouter instance
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TasksListScreen(),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SearchScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/task/new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TaskDetailsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/task/:id',
          pageBuilder: (context, state) {
            final taskId = state.pathParameters['id']!;
            return CustomTransitionPage(
              key: state.pageKey,
              child: TaskDetailsScreen(taskId: taskId),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
