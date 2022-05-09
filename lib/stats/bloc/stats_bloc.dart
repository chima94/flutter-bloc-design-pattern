import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/stats/bloc/stats_event.dart';
import 'package:todo/stats/bloc/stats_state.dart';
import 'package:todos_repository/todo_repository.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required TodoRepository todoRepository,
  })  : _todoRepository = todoRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TodoRepository _todoRepository;

  Future<void> _onSubscriptionRequested(
      StatsSubscriptionRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach<List<Todo>>(
      _todoRepository.getTodos(),
      onData: (todos) => state.copyWith(
          status: StatsStatus.success,
          completedTodos: todos.where((todo) => todo.isCompleted).length,
          activeTodos: todos.where((todo) => !todo.isCompleted).length),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
