import 'package:cleanarcapp/core/error/faliure.dart';
import 'package:cleanarcapp/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, void>> addTodo(Todo todo);
  Future<Either<Failure, void>> deleteTodo(String id);
  Future<Either<Failure, void>> toggleTodo(String id);
  Future<Either<Failure, void>> updateTodo(Todo todo);
}