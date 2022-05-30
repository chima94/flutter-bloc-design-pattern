import 'package:auth_repo/auth_repo.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/app/bloc/app_bloc.dart';
import 'package:todo/app/bloc/app_event.dart';
import 'package:todo/app/bloc/app_state.dart';
import 'package:todo/app/routes/route.dart';
import 'package:todo/home/view/home_page.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';
import 'package:todo/theme/theme_state.dart';
import 'package:todos_repository/todo_repository.dart';

class App extends StatelessWidget {
  const App(
      {Key? key,
      required TodoRepository todoRepository,
      required AuthRepo authRepo})
      : _todoRepository = todoRepository,
        _authRepo = authRepo,
        super(key: key);

  final TodoRepository _todoRepository;
  final AuthRepo _authRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepo>(
            create: (context) => _authRepo,
          ),
          RepositoryProvider<TodoRepository>(
              create: (context) => _todoRepository)
        ],
        child: BlocProvider(
            create: (_) => AppBloc(authRepo: _authRepo)..add(AppStartedEvent()),
            child: const AppView()));
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.themeData,
          darkTheme: FlutterTodosTheme.dark,
          home: FlowBuilder<AppStatus>(
            state: context.select((AppBloc bloc) => bloc.state.status),
            onGeneratePages: onGenerateAppViewPages,
          ),
        );
      }),
    );
  }
}
