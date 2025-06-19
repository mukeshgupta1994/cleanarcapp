import 'package:cleanarcapp/core/error/exception.dart';
import 'package:cleanarcapp/data/model/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleTodo(String id);
  Future<void> updateTodo(TodoModel todo);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final List<TodoModel> _todos = [
    
    // Sample data
    TodoModel(
      id: '1',
      title: 'Mukesh!',
      description: 'This is Mukesh Gupta!.',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TodoModel(
      id: '2',
      title: 'Learn Flutter',
      description: 'Study Flutter widgets.',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_todos);
    } catch (e) {
      throw CacheException('Failed to get todos: ${e.toString()}');
    }
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _todos.add(todo);
    } catch (e) {
      throw CacheException('Failed to add todo: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _todos.removeWhere((todo) => todo.id == id);
    } catch (e) {
      throw CacheException('Failed to delete todo: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleTodo(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final todo = _todos[index];
        _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      }
    } catch (e) {
      throw CacheException('Failed to toggle todo: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
      }
    } catch (e) {
      throw CacheException('Failed to update todo: ${e.toString()}');
    }
  }
}