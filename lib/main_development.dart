import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_services_binding/flutter_services_binding.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todo/bootstrap.dart';

Future<void> main() async {
  FlutterServicesBinding.ensureInitialized();
  await Firebase.initializeApp();
  final todosApi =
      LocalStorageTodosApi(plugin: await SharedPreferences.getInstance());
  boostrap(todosApi: todosApi);
}
