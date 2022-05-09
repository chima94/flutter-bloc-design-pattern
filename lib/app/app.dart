import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/home/view/home_page.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todos_repository/todo_repository.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.todoRepository}) : super(key: key);
  final TodoRepository todoRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todoRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTodosTheme.light,
      darkTheme: FlutterTodosTheme.dark,
      home: const HomePage(),
    );
  }
}
