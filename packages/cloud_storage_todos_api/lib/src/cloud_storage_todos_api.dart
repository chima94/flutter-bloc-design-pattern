import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_api/todos_api.dart';

/// {@template cloud_storage_todos_api}
/// firebase firestore todo storage
/// {@endtemplate}
class CloudStorageTodosApi extends TodosApi {
  /// {@macro cloud_storage_todos_api}
  CloudStorageTodosApi(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firebaseFirestore ?? FirebaseFirestore.instance,
        super();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<int> clearCompleted() async {
    final ref = _firestore
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .collection('My Todos');
    await ref.where('isCompleted', isEqualTo: true).get().then((res) {
      for (final data in res.docs) {
        final todo = TodoFromJson(data.data());
        ref.doc(todo.id).delete();
      }
    });
    return 0;
  }

  @override
  Future<int> completeAll({required bool completed}) async {
    final ref = _firestore
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .collection('My Todos');

    await ref.where('isCompleted', isEqualTo: !completed).get().then((res) {
      for (final data in res.docs) {
        final todo = TodoFromJson(data.data());
        final newTodo = todo.copyWith(isCompleted: completed);
        ref.doc(newTodo.id).set(newTodo.toJson());
      }
    });

    return 0;
  }

  @override
  Future<void> deleteTodo(String id) async {
    final ref = _firestore
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .collection('My Todos');
    await ref.doc(id).delete();
  }

  @override
  Stream<List<Todo>> getTodos() {
    // TODO: implement getTodos
    throw UnimplementedError();
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .collection('My Todos')
        .doc(todo.id)
        .set(todo.toJson());
  }

  @override
  Future<List<Todo>> getTodoFromCloud() async {
    var result = <Todo>[];
    final ref = _firestore
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .collection('My Todos');

    await ref.get().then((res) {
      for (final data in res.docs) {
        final todo = TodoFromJson(data.data());
        result.add(todo);
      }
    });
    return result;
  }
}
