import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo_overview/bloc/todo_overview_event.dart';
import 'package:todo/todo_overview/bloc/todo_overview_state.dart';
import 'package:todos_repository/todo_repository.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewSubcriptionRequested>(_onSubscriptionRequested);
    on<TodosOverviewTodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodosOverviewTodoDeleted>(_onTodoDeleted);
    on<TodosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TodosOverviewFilterChanged>(_onFilterChanged);
    on<TodosOverviewToggleAllRequested>(_onToggleAllRequested);
    on<TodosOverviewClearCompletedRequested>(_onClearCompletedRequested);
    on<TodoRefreshFromCloud>(_onRefreshFromCloud);
  }

  final TodoRepository _todoRepository;

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubcriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));
    await emit.forEach<List<Todo>>(_todoRepository.getTodos(),
        onData: (todos) => state.copyWith(
              status: () => TodosOverviewStatus.success,
              todos: () => todos,
            ),
        onError: (_, __) =>
            state.copyWith(status: () => TodosOverviewStatus.failure));
  }

  Future<void> _onTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todoRepository.saveTodo(newTodo);
  }

  Future<void> _onTodoDeleted(
      TodosOverviewTodoDeleted event, Emitter<TodosOverviewState> emit) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todoRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
      TodosOverviewUndoDeletionRequested event,
      Emitter<TodosOverviewState> emit) async {
    assert(state.lastDeletedTodo != null, 'Last deleted todo cannot be null');

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todoRepository.saveTodo(todo);
  }

  void _onFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodosOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    TodosOverviewToggleAllRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todoRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
    TodosOverviewClearCompletedRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    await _todoRepository.clearCompleted();
  }

  Future<void> _onRefreshFromCloud(
    TodoRefreshFromCloud event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));
    final todos = await _todoRepository.getTodosFromCloud();
    for (final todo in todos) {
      print(todo);
      await _todoRepository.saveTodo(todo);
    }
    emit(state.copyWith(status: () => TodosOverviewStatus.success));
  }
}
