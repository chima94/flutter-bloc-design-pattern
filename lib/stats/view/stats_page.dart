import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/stats/bloc/stats_bloc.dart';
import 'package:todo/stats/bloc/stats_event.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';
import 'package:todos_repository/todo_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatsBloc(todoRepository: context.read<TodoRepository>())
            ..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;
    final themeData = context.select(
      (ThemeBloc bloc) => bloc.state.themeData,
    );
    final appbarColor = themeData == FlutterTodosTheme.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : null;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Stats of Todos'),
        backgroundColor: appbarColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            key: const Key('statsView_completedTodos_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: const Text(
              'Completed Todos',
            ),
            trailing:
                Text('${state.completedTodos}', style: textTheme.headline5),
          ),
          ListTile(
            key: const Key('statsView_activeTodos_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: const Text('Active Todos'),
            trailing: Text('${state.activeTodos}', style: textTheme.headline5),
          )
        ],
      ),
    );
  }
}
