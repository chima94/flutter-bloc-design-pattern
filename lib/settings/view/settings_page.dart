import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/app/bloc/app_bloc.dart';
import 'package:todo/app/bloc/app_event.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => context.read<AppBloc>().add(AppLogoutRequested()),
        child: const Center(
          child: Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
