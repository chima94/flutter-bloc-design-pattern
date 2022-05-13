import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/app/bloc/app_bloc.dart';
import 'package:todo/app/bloc/app_event.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item(user.email!, Icons.account_circle_outlined),
            _divider(),
            _item('Github repo', Icons.engineering_outlined),
            _divider(),
            _item('Theme', Icons.brightness_7_outlined, theme: true),
            _divider(),
            _item('Sign out', Icons.logout_outlined, logout: true),
          ],
        ),
      ),
    );
  }
}

Row _item(String title, IconData icon,
    {bool logout = false, bool theme = false}) {
  return Row(
    children: [
      Icon(
        icon,
        color: logout ? const Color(0xFF13B9FF) : Colors.black,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: logout ? const Color(0xFF13B9FF) : Colors.black,
        ),
      ),
      if (theme)
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Switch.adaptive(
                activeColor: const Color(0xFF13B9FF),
                value: true,
                onChanged: (value) {},
              )
            ],
          ),
        )
      else
        Container()
    ],
  );
}

Divider _divider({int height = 40}) {
  return Divider(
    height: height.toDouble(),
    thickness: 0.5,
    indent: 0,
    endIndent: 0,
    color: Colors.grey,
  );
}

  // GestureDetector(
  //       onTap: () => context.read<AppBloc>().add(AppLogoutRequested()),
  //       child: const Center(
  //         child: Text(
  //           'Settings',
  //           style: TextStyle(color: Colors.black),
  //         ),
  //       ),