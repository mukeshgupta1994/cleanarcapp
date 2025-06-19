import 'package:cleanarcapp/domain/usecaase/add_todo.dart';
import 'package:cleanarcapp/domain/usecaase/delete_todo.dart';
import 'package:cleanarcapp/domain/usecaase/get_todos.dart';
import 'package:cleanarcapp/domain/usecaase/toggle_todo.dart';
import 'package:cleanarcapp/presentation/provider/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/injection_container.dart' as di;
import 'presentation/pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (_) => TodoProvider(
                  getTodos: di.sectionList<GetTodos>(),
                  addTodo: di.sectionList<AddTodo>(),
                  deleteTodo: di.sectionList<DeleteTodo>(),
                  toggleTodo: di.sectionList<ToggleTodo>(),
                ))
      ],
      child: MaterialApp(
        title: 'Todo Clean Architecture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodoPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
