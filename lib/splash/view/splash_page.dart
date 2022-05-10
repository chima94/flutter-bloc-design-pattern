import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SplashPage());

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('splash screen'),
    );
  }
}
