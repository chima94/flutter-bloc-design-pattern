import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/edit_todo/view/edit_todo.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';
import 'package:todo/todo_overview/bloc/todo_overview_bloc.dart';
import 'package:todo/todo_overview/bloc/todo_overview_event.dart';
import 'package:todo/todo_overview/bloc/todo_overview_state.dart';
import 'package:todo/todo_overview/view/widget/date_task_bar.dart';
import 'package:todo/todo_overview/view/widget/todo_tiles.dart';
import 'package:todo/todo_overview/view/widget/todos_overview_filter_button.dart';
import 'package:todo/widget/dialog/loading_screen.dart';
import 'package:todos_repository/todo_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todoRepository: context.read<TodoRepository>(),
      )..add(const TodosOverviewSubcriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.select(
      (ThemeBloc bloc) => bloc.state.themeData,
    );
    final appbarColor = themeData == FlutterTodosTheme.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : null;
    final date = context.select((TodosOverviewBloc bloc) => bloc.state.date);
    final selectedDate = date ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('My Todo'),
        backgroundColor: appbarColor,
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == TodosOverviewStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text('An error occured while loading todos')));
                }

                if (state.status == TodosOverviewStatus.loading) {
                  LoadingScreen.instance()
                      .show(context: context, text: 'Loading');
                } else {
                  LoadingScreen.instance().hide();
                }
              }),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);

              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Todo ${deletedTodo.title} was deleted'),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context
                              .read<TodosOverviewBloc>()
                              .add(const TodosOverviewUndoDeletionRequested());
                        }),
                  ),
                );
            },
          )
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
            builder: (context, state) {
          if (state.todos.isEmpty) {
            if (state.status == TodosOverviewStatus.loading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state.status != TodosOverviewStatus.success) {
              return const SizedBox();
            } else {
              return Center(
                child: Text(
                  'No todo found with the selected filter',
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            }
          }
          return Column(
            children: [
              AddDateTaskBar(
                dateTime: (date) {
                  context
                      .read<TodosOverviewBloc>()
                      .add(TodoOverviewDateTimeChanged(date));
                },
              ),
              const Divider(
                height: 8,
                thickness: 1,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: state.filteredTodos.length,
                    itemBuilder: (_, index) {
                      final todo = state.filteredTodos.toList()[index];
                      if (todo.repeat == 'Daily') {
                        return TodoListTiles(
                          todo: todo,
                          onToggleCompleted: (isCompleted) {
                            context.read<TodosOverviewBloc>().add(
                                TodosOverviewTodoCompletionToggled(
                                    todo: todo, isCompleted: isCompleted));
                          },
                          onDismissed: (_) {
                            context
                                .read<TodosOverviewBloc>()
                                .add(TodosOverviewTodoDeleted(todo));
                          },
                          onTap: () {
                            Navigator.of(context)
                                .push(EditTodoPage.route(initialTodo: todo));
                          },
                        );
                      }

                      if (todo.date == DateFormat.yMd().format(date!)) {
                        return TodoListTiles(
                          todo: todo,
                          onToggleCompleted: (isCompleted) {
                            context.read<TodosOverviewBloc>().add(
                                TodosOverviewTodoCompletionToggled(
                                    todo: todo, isCompleted: isCompleted));
                          },
                          onDismissed: (_) {
                            context
                                .read<TodosOverviewBloc>()
                                .add(TodosOverviewTodoDeleted(todo));
                          },
                          onTap: () {
                            Navigator.of(context)
                                .push(EditTodoPage.route(initialTodo: todo));
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}



// CupertinoScrollbar(
//             child: ListView(
//               children: [
//                 AddDateTaskBar(
//                   dateTime: (date) {
//                     context
//                         .read<TodosOverviewBloc>()
//                         .add(TodoOverviewDateTimeChanged(date));
//                   },
//                 ),
//                 const Divider(
//                   height: 8,
//                   thickness: 1,
//                 ),
//                 for (final todo in state.filteredTodos)
                  
//                   
                  
//               ],
//             ),
//           );
