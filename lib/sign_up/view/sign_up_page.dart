import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/sign_up/bloc/sign_up_bloc.dart';
import 'package:todo/sign_up/view/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 0,
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
