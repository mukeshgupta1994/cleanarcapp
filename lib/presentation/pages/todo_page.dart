import 'package:cleanarcapp/core/injection_container.dart' as di;
import 'package:cleanarcapp/presentation/provider/todo_provider.dart';
import 'package:cleanarcapp/presentation/widgets/add_todo_dialog.dart';
import 'package:cleanarcapp/presentation/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sectionList<TodoProvider>()..loadTodos(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clean Architecture Todo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
          actions: [
            Consumer<TodoProvider>(
              builder: (context, provider, _) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: provider.isLoading ? null : () => provider.loadTodos(),
                );
              },
            ),
          ],
        ),
        body: Consumer<TodoProvider>(
          builder: (context, provider, child) {
            if (provider.errorMessage.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Dismiss',
                      textColor: Colors.white,
                      onPressed: () => provider.clearError(),
                    ),
                  ),
                );
              });
            }

            switch (provider.state) {
              case TodoState.initial:
              case TodoState.loading: 
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading todos...'),
                    ],
                  ),
                );
              case TodoState.error:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${provider.errorMessage}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => provider.loadTodos(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              case TodoState.loaded:
                return Column(
                  children: [
                    Expanded(
                      child: provider.todos.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.checklist,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No todos yet!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap the + button to add your first todo.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => provider.loadTodos(),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: provider.todos.length,
                                itemBuilder: (context, index) {
                                  final todo = provider.todos[index];
                                  return TodoItem(
                                    key: ValueKey(todo.id),
                                    todo: todo,
                                    onToggle: () => provider.toggleTodoStatus(todo.id),
                                    onDelete: () => _showDeleteConfirmation(context, provider, todo.id, todo.title),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
            }
          },
        ),
        floatingActionButton: Consumer<TodoProvider>(
          builder: (context, provider, _) {
            return FloatingActionButton(
              onPressed: provider.isLoading ? null : () => _showAddTodoDialog(context),
              child: provider.isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TodoProvider provider, String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.removeTodo(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}