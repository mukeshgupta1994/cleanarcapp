import 'package:cleanarcapp/core/error/faliure.dart';
import 'package:cleanarcapp/domain/repositories/repositories.dart';
import 'package:dartz/dartz.dart';

class ToggleTodo {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleTodo(id);
  }
}