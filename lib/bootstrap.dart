import 'dart:async';
import 'dart:developer';
import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/app/app.dart';
import 'package:todo/app/app_bloc_observer.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todo_repository.dart';

void boostrap({
  required TodosApi todosApi,
}) {
  FlutterError.onError = (details) {
    log(
      details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  final todoRepository = TodoRepository(
    todosApi: todosApi,
  );
  final authRepository = AuthRepo();

  runZonedGuarded(
    () async {
      await authRepository.user.first;
      await BlocOverrides.runZoned(
        () async => runApp(
          App(
            todoRepository: todoRepository,
            authRepo: authRepository,
          ),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(
      error.toString(),
      stackTrace: stackTrace,
    ),
  );
}
