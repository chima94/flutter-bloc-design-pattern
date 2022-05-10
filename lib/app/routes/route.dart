import 'package:flutter/cupertino.dart';
import 'package:todo/app/bloc/app_state.dart';
import 'package:todo/home/view/home_page.dart';
import 'package:todo/login/view/login.dart';
import 'package:todo/splash/view/splash_page.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> page) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.appStarted:
      return [SplashPage.page()];
  }
}
