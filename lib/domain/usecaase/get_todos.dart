import 'package:cleanarcapp/core/error/faliure.dart';
import 'package:cleanarcapp/domain/entities/todo.dart';
import 'package:cleanarcapp/domain/repositories/repositories.dart';
import 'package:dartz/dartz.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() async {
    return await repository.getTodos();
  }
}