import 'dart:convert';

import 'package:todos_api/src/models/todo.dart';

Todo TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      repeat: json['repeat'] as String? ?? '',
      notificationId: json['notificationId'] as int? ?? 0,
    );

Map<String, dynamic> TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'date': instance.date,
      'startTime': instance.startTime,
      'repeat': instance.repeat,
      'notificationId': instance.notificationId,
    };
