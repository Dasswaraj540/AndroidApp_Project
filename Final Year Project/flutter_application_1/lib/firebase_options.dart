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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCvaZ6CuKXz8W6AW1je8PR76vGayZ66A3k',
    appId: '1:1028069131979:web:b14d43ea5e3b3c794c7d4e',
    messagingSenderId: '1028069131979',
    projectId: 'signup-info-cc273',
    authDomain: 'signup-info-cc273.firebaseapp.com',
    storageBucket: 'signup-info-cc273.appspot.com',
    measurementId: 'G-HRKYQ5MYGW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDAQVaSj1AvFq9pngIJYqpy3Plav8NqDk',
    appId: '1:1028069131979:android:552e7711d77cabea4c7d4e',
    messagingSenderId: '1028069131979',
    projectId: 'signup-info-cc273',
    storageBucket: 'signup-info-cc273.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClP1gfHVobwycfqSAy-cdB6rWsG-WNx5M',
    appId: '1:1028069131979:ios:808d8028dd922e3e4c7d4e',
    messagingSenderId: '1028069131979',
    projectId: 'signup-info-cc273',
    storageBucket: 'signup-info-cc273.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClP1gfHVobwycfqSAy-cdB6rWsG-WNx5M',
    appId: '1:1028069131979:ios:763a0d618cf134de4c7d4e',
    messagingSenderId: '1028069131979',
    projectId: 'signup-info-cc273',
    storageBucket: 'signup-info-cc273.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
