import 'package:cleanarcapp/core/error/exception.dart';
import 'package:cleanarcapp/core/error/faliure.dart';
import 'package:cleanarcapp/data/datasources/todo_local_data_source.dart';
import 'package:cleanarcapp/data/model/todo_model.dart';
import 'package:cleanarcapp/domain/entities/todo.dart';
import 'package:cleanarcapp/domain/repositories/repositories.dart';
import 'package:dartz/dartz.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await localDataSource.getTodos();
      return Right(todos);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      await localDataSource.addTodo(todoModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await localDataSource.deleteTodo(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTodo(String id) async {
    try {
      await localDataSource.toggleTodo(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      await localDataSource.updateTodo(todoModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }
}