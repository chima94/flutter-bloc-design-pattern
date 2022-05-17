import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todos_api/src/models/todo_serialize.dart';
import 'package:uuid/uuid.dart';

@immutable
@JsonSerializable()
class Todo extends Equatable {
  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.date = '',
    this.startTime = '',
    this.repeat = '',
    this.notificationId = 0,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  final String id;

  final String title;

  final String description;

  final bool isCompleted;

  final String date;

  final String startTime;

  final String repeat;

  final int notificationId;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? date,
    String? startTime,
    String? repeat,
    int? notificationId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      repeat: repeat ?? this.repeat,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  static Todo fromJson(JsonMap json) => TodoFromJson(json);
  JsonMap toJson() => TodoToJson(this);

  @override
  List<Object> get props => [
        id,
        title,
        description,
        isCompleted,
      ];
}

typedef JsonMap = Map<String, dynamic>;
