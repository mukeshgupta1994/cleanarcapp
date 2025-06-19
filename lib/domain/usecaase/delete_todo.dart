import 'package:cleanarcapp/core/error/faliure.dart';
import 'package:cleanarcapp/domain/repositories/repositories.dart';
import 'package:dartz/dartz.dart';


class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTodo(id);
  }
}