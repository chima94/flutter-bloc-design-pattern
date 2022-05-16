import 'package:equatable/equatable.dart';

abstract class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object> get props => [];
}

class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditTodoDescriptionChanged extends EditTodoEvent {
  const EditTodoDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class EditTodoDateChanged extends EditTodoEvent {
  const EditTodoDateChanged(this.date);
  final String date;

  @override
  List<Object> get props => [date];
}

class EditTodoRepeatChanged extends EditTodoEvent {
  const EditTodoRepeatChanged(this.repeat);
  final String repeat;

  @override
  List<Object> get props => [repeat];
}

class EditTodoStartTimeChanged extends EditTodoEvent {
  const EditTodoStartTimeChanged(this.startTime);
  final String startTime;

  @override
  List<Object> get props => [startTime];
}

class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}
