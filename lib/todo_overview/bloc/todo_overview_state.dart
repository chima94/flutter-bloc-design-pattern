import 'package:equatable/equatable.dart';
import 'package:todo/todo_overview/model/todo_view_filter.dart';
import 'package:todos_repository/todo_repository.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
    this.date,
  });

  final TodosOverviewStatus status;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;
  final DateTime? date;

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
    DateTime? Function()? date,
  }) {
    return TodosOverviewState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
      date: date != null ? date() : this.date,
    );
  }

  @override
  List<Object?> get props => [status, todos, filter, lastDeletedTodo, date];
}
