import 'package:cloud_storage_todos_api/cloud_storage_todos_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_services_binding/flutter_services_binding.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todo/bootstrap.dart';

Future<void> main() async {
  FlutterServicesBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cloudTodoApi = CloudStorageTodosApi();
  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
    cloudStorageTodosApi: cloudTodoApi,
  );
  boostrap(todosApi: todosApi);
}
