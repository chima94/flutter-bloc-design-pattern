import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/app/bloc/app_bloc.dart';
import 'package:todo/app/bloc/app_event.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/theme/theme_bloc.dart';
import 'package:todo/theme/theme_event.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.select((ThemeBloc bloc) => bloc.state.themeData);
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final textStyle = Theme.of(context).textTheme.bodyText1;
    final theme = context.select(
      (ThemeBloc bloc) => bloc.state.themeData,
    );
    final appbarColor = theme == FlutterTodosTheme.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 2,
        backgroundColor: appbarColor,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item(
              user.email!,
              Icons.account_circle_outlined,
              textStyle: textStyle,
            ),
            _divider(),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse(
                    'https://github.com/chima94/flutter-bloc-design-pattern');
                await launchUrl(
                  url,
                );
              },
              child: _item(
                'Github repo',
                Icons.engineering_outlined,
                textStyle: textStyle,
              ),
            ),
            _divider(),
            _item(
              'Theme',
              Icons.brightness_7_outlined,
              themeData: themeData,
              textStyle: textStyle,
              isTheme: (value) {
                context.read<ThemeBloc>().add(ThemeEvent(value: value));
              },
            ),
            _divider(),
            GestureDetector(
              onTap: () => context.read<AppBloc>().add(AppLogoutRequested()),
              child: _item(
                'Sign out',
                Icons.logout_outlined,
                logout: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Row _item(
  String title,
  IconData icon, {
  bool logout = false,
  ThemeData? themeData,
  Function(bool)? isTheme,
  TextStyle? textStyle,
}) {
  return Row(
    children: [
      Icon(
        icon,
        color: logout ? const Color(0xFF13B9FF) : null,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(title, style: textStyle),
      if (themeData != null)
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Switch.adaptive(
                activeColor: const Color(0xFF13B9FF),
                value: themeData == FlutterTodosTheme.dark,
                onChanged: (value) {
                  isTheme!(value);
                },
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
