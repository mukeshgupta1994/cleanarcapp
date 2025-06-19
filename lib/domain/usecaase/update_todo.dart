import 'package:cleanarcapp/core/error/faliure.dart';
import 'package:cleanarcapp/domain/entities/todo.dart';
import 'package:cleanarcapp/domain/repositories/repositories.dart';
import 'package:dartz/dartz.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<Either<Failure, void>> call(Todo todo) async {
    return await repository.updateTodo(todo);
  }
}