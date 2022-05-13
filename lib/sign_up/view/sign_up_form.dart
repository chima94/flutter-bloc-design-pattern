import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todo/home/cubit/home_cubit.dart';
import 'package:todo/sign_up/bloc/sign_up_bloc.dart';
import 'package:todo/sign_up/bloc/sign_up_state.dart';
import 'package:todo/widget/dialog/loading_screen.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const SignupForm(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
        if (state.status.isSubmissionInProgress) {
          LoadingScreen.instance().show(context: context, text: 'Loading');
        } else {
          LoadingScreen.instance().hide();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _EmailInput(),
          SizedBox(height: 8),
          _PasswordInput(),
          SizedBox(height: 8),
          _ConfirmPasswordInput(),
          SizedBox(height: 8),
          _SignButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextField(
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'email',
                helperText: '',
                errorText: state.email.invalid ? 'invalid email' : null),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            onChanged: (password) =>
                context.read<SignUpCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'password',
              helperText: '',
              errorText: state.password.invalid ? 'invalid password' : null,
            ),
          );
        });
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            current.confirmedPassword != previous.confirmedPassword,
        builder: (context, state) {
          return TextField(
            onChanged: (confirmPassword) => context
                .read<SignUpCubit>()
                .confirmedPasswordChanged(confirmPassword),
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'confirm password',
                helperText: '',
                errorText: state.confirmedPassword.invalid
                    ? 'passwords do not match'
                    : null),
          );
        });
  }
}

class _SignButton extends StatelessWidget {
  const _SignButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: Colors.orangeAccent,
          ),
          onPressed: state.status.isValidated
              ? () => context.read<SignUpCubit>().signUpFormSubmitted()
              : null,
          child: const Text('Sign Up'),
        );
      },
    );
  }
}
