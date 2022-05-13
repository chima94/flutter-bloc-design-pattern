import 'package:cloud_storage_todos_api/cloud_storage_todos_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_services_binding/flutter_services_binding.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todo/bootstrap.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        // navigation bar color
        statusBarColor: Color(0xFF13B9FF),
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark // status bar color
        ),
  );
  FlutterServicesBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cloudTodoApi = CloudStorageTodosApi();
  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
    cloudStorageTodosApi: cloudTodoApi,
  );
  boostrap(todosApi: todosApi);
}
