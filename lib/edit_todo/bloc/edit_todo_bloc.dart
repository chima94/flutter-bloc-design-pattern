import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/edit_todo/bloc/edit_todo_event.dart';
import 'package:todo/edit_todo/bloc/edit_todo_state.dart';
import 'package:todos_repository/todo_repository.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc(
      {required TodoRepository todoRepository, required Todo? initialTodo})
      : _todoRepository = todoRepository,
        super(EditTodoState(
          initialTodo: initialTodo,
          title: initialTodo?.title ?? '',
          description: initialTodo?.description ?? '',
          startTime: initialTodo?.startTime ?? '',
          date: initialTodo?.date ?? '',
          repeat: initialTodo?.repeat ?? '',
        )) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoDateChanged>(_onDateChanged);
    on<EditTodoStartTimeChanged>(_onStartTime);
    on<EditTodoRepeatChanged>(_onRepeatChanged);
    on<EditTodoSubmitted>(_onSubmitted);
  }

  final TodoRepository _todoRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onDateChanged(EditTodoDateChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onStartTime(
      EditTodoStartTimeChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(startTime: event.startTime));
  }

  void _onRepeatChanged(
      EditTodoRepeatChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(repeat: event.repeat));
  }

  Future<void> _onSubmitted(
      EditTodoSubmitted event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
      date: state.date,
      startTime: state.startTime,
      repeat: state.repeat,
    );

    try {
      await _todoRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
