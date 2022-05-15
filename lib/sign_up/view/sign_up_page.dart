import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/sign_up/bloc/sign_up_bloc.dart';
import 'package:todo/sign_up/view/sign_up_form.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

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
        title: const Text('Sign Up'),
        elevation: 2,
        backgroundColor: appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => SignUpCubit(context.read<AuthRepo>()),
          child: const SignupForm(),
        ),
      ),
    );
  }
}
