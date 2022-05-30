import 'package:cloud_storage_todos_api/cloud_storage_todos_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_services_binding/flutter_services_binding.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todo/bootstrap.dart';
import 'package:todo/service/notification_service.dart';
import 'package:todo/theme/sharepreference.dart';

Future<void> main() async {
  FlutterServicesBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        // navigation bar color
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.dark // status bar color
        ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await Preferences.init();
  await NotifyHelper.initializeNotification();
  NotifyHelper.requestIOSPermissions();
  final cloudTodoApi = CloudStorageTodosApi();
  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
    cloudStorageTodosApi: cloudTodoApi,
  );
  boostrap(todosApi: todosApi);
}
