import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/login/cubit/login_cubit.dart';
import 'package:todo/login/view/login_form.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final themeData = context.select(
      (ThemeBloc bloc) => bloc.state.themeData,
    );
    final appbarColor = themeData == FlutterTodosTheme.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : null;
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text('Login'),
          backgroundColor: appbarColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocProvider(
            create: (_) => LoginCubit(context.read<AuthRepo>()),
            child: const LoginForm(),
          ),
        ));
  }
}
