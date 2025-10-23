import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_plus/domain/entities/task.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_event.dart';
import 'package:planner_plus/presentation/bloc/tasks/tasks_state.dart';
import 'package:planner_plus/presentation/widgets/task_list_item.dart';

/// Search screen for finding tasks
class SearchScreen extends StatefulWidget {
  /// Creates a new SearchScreen
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Task> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final state = context.read<TasksBloc>().state;
    if (state is TasksLoaded) {
      final results = state.tasks.where((task) {
        final titleMatch = task.title.toLowerCase().contains(query.toLowerCase());
        final descriptionMatch =
            task.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final tagsMatch = task.tags
            .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        return titleMatch || descriptionMatch || tagsMatch;
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: Theme.of(context).textTheme.titleLarge,
          onChanged: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (_isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_searchController.text.isEmpty) {
            return _buildRecentSearches(context);
          }

          if (_searchResults.isEmpty) {
            return _buildNoResults(context);
          }

          return ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return TaskListItem(
                task: _searchResults[index],
                onTap: () => context.push('/task/${_searchResults[index].id}'),
                onToggle: (task) => context
                    .read<TasksBloc>()
                    .add(ToggleTaskCompletionEvent(task)),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search tasks',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a keyword to search',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}
