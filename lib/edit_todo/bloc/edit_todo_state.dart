import 'package:equatable/equatable.dart';
import 'package:todos_repository/todo_repository.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

class EditTodoState extends Equatable {
  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
    this.date = '',
    this.repeat = '',
    this.startTime = '',
  });

  final EditTodoStatus status;
  final Todo? initialTodo;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String repeat;

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    Todo? initialTodo,
    String? title,
    String? description,
    String? date,
    String? startTime,
    String? repeat,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      repeat: repeat ?? this.repeat,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialTodo,
        title,
        description,
        date,
        startTime,
        repeat,
      ];
}
