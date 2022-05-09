import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo_overview/bloc/todo_overview_bloc.dart';
import 'package:todo/todo_overview/bloc/todo_overview_event.dart';
import 'package:todo/todo_overview/model/todo_view_filter.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((TodosOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip:
          'Tooltip text shown in the filter dropdown of the Todos Overview Page',
      onSelected: (filter) {
        context
            .read<TodosOverviewBloc>()
            .add(TodosOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text('All'),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text('Active only'),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text('Completed'),
          )
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodosOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: 'Option',
      onSelected: (options) {
        switch (options) {
          case TodosOverviewOption.toggleAll:
            context
                .read<TodosOverviewBloc>()
                .add(const TodosOverviewToggleAllRequested());
            break;
          case TodosOverviewOption.clearCompleted:
            context
                .read<TodosOverviewBloc>()
                .add(const TodosOverviewClearCompletedRequested());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosOverviewOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? 'Mark all as completed'
                  : 'Mark all as incomplete',
            ),
          ),
          PopupMenuItem(
            value: TodosOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: const Text('Clear completed'),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
