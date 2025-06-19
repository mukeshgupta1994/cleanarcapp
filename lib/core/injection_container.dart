import 'package:cleanarcapp/data/datasources/todo_local_data_source.dart';
import 'package:cleanarcapp/data/repositories/todo_repository_impl.dart';
import 'package:cleanarcapp/domain/repositories/repositories.dart';
import 'package:cleanarcapp/domain/usecaase/add_todo.dart';
import 'package:cleanarcapp/domain/usecaase/delete_todo.dart';
import 'package:cleanarcapp/domain/usecaase/get_todos.dart';
import 'package:cleanarcapp/domain/usecaase/toggle_todo.dart';
import 'package:cleanarcapp/presentation/provider/todo_provider.dart';
import 'package:get_it/get_it.dart';

final sectionList = GetIt.instance;

Future<void> init() async {
  // Providers
  sectionList.registerFactory(() => TodoProvider(
    getTodos: sectionList(),
    addTodo: sectionList(),
    deleteTodo: sectionList(),
    toggleTodo: sectionList(),
  ));

  // Use cases
  sectionList.registerLazySingleton(() => GetTodos(sectionList()));
  sectionList.registerLazySingleton(() => AddTodo(sectionList()));
  sectionList.registerLazySingleton(() => DeleteTodo(sectionList()));
  sectionList.registerLazySingleton(() => ToggleTodo(sectionList()));

  // Repository
  sectionList.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(localDataSource: sectionList()),
  );

  // Data sources
  sectionList.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(),
  );
}