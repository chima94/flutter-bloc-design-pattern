import 'package:todos_api/todos_api.dart';

import 'models/todo.dart';

abstract class TodosApi {
  const TodosApi();

  Stream<List<Todo>> getTodos();

  Future<void> saveTodo(Todo todo);

  Future<void> deleteTodo(String id);

  Future<int> clearCompleted();

  Future<int> completeAll({required bool completed});
}

class TodoNotFoundException implements Exception {}
