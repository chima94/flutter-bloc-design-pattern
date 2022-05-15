import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/theme/app_theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SplashPage());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Todo APP with Bloc Design Pattern',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
