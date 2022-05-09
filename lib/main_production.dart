import 'package:flutter_services_binding/flutter_services_binding.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todo/bootstrap.dart';

Future<void> main() async {
  FlutterServicesBinding.ensureInitialized();
  final todosApi =
      LocalStorageTodosApi(plugin: await SharedPreferences.getInstance());

  boostrap(todosApi: todosApi);
}
