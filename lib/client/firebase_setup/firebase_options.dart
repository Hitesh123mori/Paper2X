// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'project_1.dart';
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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyBYSyqJXJdqLrqWaSGqqo-ajmlvqOFm6Aw",
      authDomain: "paper2x.firebaseapp.com",
      projectId: "paper2x",
      storageBucket: "paper2x.firebasestorage.app",
      messagingSenderId: "94924256176",
      appId: "1:94924256176:web:30d4d33e26a692c31f9c75",
      measurementId: "G-H1CLLE0JEV"
  );

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyBYSyqJXJdqLrqWaSGqqo-ajmlvqOFm6Aw",
      authDomain: "paper2x.firebaseapp.com",
      projectId: "paper2x",
      storageBucket: "paper2x.firebasestorage.app",
      messagingSenderId: "94924256176",
      appId: "1:94924256176:web:30d4d33e26a692c31f9c75",
      measurementId: "G-H1CLLE0JEV"
  );




}