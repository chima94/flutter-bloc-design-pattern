import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todos_api/src/models/todo_serialize.dart';
import 'package:uuid/uuid.dart';

@immutable
@JsonSerializable()
class Todo extends Equatable {
  Todo(
      {String? id,
      required this.title,
      this.description = '',
      this.isCompleted = false})
      : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  final String id;

  final String title;

  final String description;

  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static Todo fromJson(JsonMap json) => TodoFromJson(json);
  JsonMap toJson() => TodoToJson(this);

  @override
  List<Object> get props => [id, title, description, isCompleted];
}

typedef JsonMap = Map<String, dynamic>;
