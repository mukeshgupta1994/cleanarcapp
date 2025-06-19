import 'package:cleanarcapp/domain/entities/todo.dart';
import 'package:cleanarcapp/domain/usecaase/add_todo.dart';
import 'package:cleanarcapp/domain/usecaase/delete_todo.dart';
import 'package:cleanarcapp/domain/usecaase/get_todos.dart';
import 'package:cleanarcapp/domain/usecaase/toggle_todo.dart';
import 'package:flutter/foundation.dart';

enum TodoState { initial, loading, loaded, error }

class TodoProvider with ChangeNotifier {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodo toggleTodo;

  TodoProvider({
    required this.getTodos,
    required this.addTodo,
    required this.deleteTodo,
    required this.toggleTodo,
  });

  TodoState _state = TodoState.initial;
  List<Todo> _todos = [];
  String _errorMessage = '';
  bool _isLoading = false;

  TodoState get state => _state;
  List<Todo> get todos => _todos;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  List<Todo> get completedTodos => _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodos => _todos.where((todo) => !todo.isCompleted).toList();

  Future<void> loadTodos() async {
    _state = TodoState.loading;
    _isLoading = true;
    notifyListeners();

    final result = await getTodos();
    result.fold(
      (failure) {
        _state = TodoState.error;
        _errorMessage = _getFailureMessage(failure);
        _isLoading = false;
      },
      (todos) {
        _state = TodoState.loaded;
        _todos = todos;
        _errorMessage = '';
        _isLoading = false;
      },
    );
    notifyListeners();
  }

  Future<void> addNewTodo(String title, String description) async {
    if (title.trim().isEmpty) {
      _errorMessage = 'Title cannot be empty';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    final result = await addTodo(todo);
    result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (_) {
        _errorMessage = '';
        _isLoading = false;
        loadTodos();
      },
    );
  }

  Future<void> removeTodo(String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await deleteTodo(id);
    result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (_) {
        _errorMessage = '';
        _isLoading = false;
        loadTodos();
      },
    );
  }

  Future<void> toggleTodoStatus(String id) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      final updatedTodo = _todos[todoIndex].copyWith(
        isCompleted: !_todos[todoIndex].isCompleted,
      );
      _todos[todoIndex] = updatedTodo;
      notifyListeners();
    }

    final result = await toggleTodo(id);
    result.fold(
      (failure) {
        if (todoIndex != -1) {
          final revertedTodo = _todos[todoIndex].copyWith(
            isCompleted: !_todos[todoIndex].isCompleted,
          );
          _todos[todoIndex] = revertedTodo;
        }
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
      },
      (_) {
        _errorMessage = '';
      },
    );
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  String _getFailureMessage(failure) {
    return failure.toString().replaceAll('CacheFailure: ', '');
  }
}