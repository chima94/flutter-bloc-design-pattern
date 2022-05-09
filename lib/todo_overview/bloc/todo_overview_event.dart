import 'package:equatable/equatable.dart';
import 'package:todos_repository/todo_repository.dart';

import '../model/todo_view_filter.dart';

abstract class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

class TodosOverviewSubcriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubcriptionRequested();
}

class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompletionToggled(
      {required this.todo, required this.isCompleted});

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo];
}

class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequested();
}
