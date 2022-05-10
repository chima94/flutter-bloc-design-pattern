// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC1jZIHs5uxYwCyROmGj_YCbmj_xxsZaVY',
    appId: '1:311087396382:web:932c7f7776f4a447d2e00f',
    messagingSenderId: '311087396382',
    projectId: 'flutter-project-cd13d',
    authDomain: 'flutter-project-cd13d.firebaseapp.com',
    storageBucket: 'flutter-project-cd13d.appspot.com',
    measurementId: 'G-Y99L8M92J8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmdMcrlDd380iFgDYFEn1bY7GCR31PJ-M',
    appId: '1:311087396382:android:a8b55bc41328aaf2d2e00f',
    messagingSenderId: '311087396382',
    projectId: 'flutter-project-cd13d',
    storageBucket: 'flutter-project-cd13d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuKDjQAUjQ8OuGnVgEKG9aqx9zmvBtEH0',
    appId: '1:311087396382:ios:c7415a03c1d499a2d2e00f',
    messagingSenderId: '311087396382',
    projectId: 'flutter-project-cd13d',
    storageBucket: 'flutter-project-cd13d.appspot.com',
    iosClientId: '311087396382-75mtsg43u7j224pdlg5onmg53h7vt40r.apps.googleusercontent.com',
    iosBundleId: 'com.example.verygoodcore.todo',
  );
}