// File derived from the FlutterFire CLI output and maintained by the team.
//
// The API keys are NOT hardcoded in this file. They are injected at build
// time from environment variables populated by `--dart-define-from-file=.env`.
// See `.env.example` and `docs/architecture/DATABASE.md` section 5.
//
// ignore_for_file: type=lint
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
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  /// Web options. `apiKey` comes from `FIREBASE_WEB_API_KEY` in `.env`.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY'),
    appId: '1:775519398467:web:8e00611e4dfe8cc81bc2f6',
    messagingSenderId: '775519398467',
    projectId: 'reencontrapp',
    authDomain: 'reencontrapp.firebaseapp.com',
    storageBucket: 'reencontrapp.firebasestorage.app',
  );

  /// Android options. `apiKey` comes from `FIREBASE_ANDROID_API_KEY` in `.env`.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
    appId: '1:775519398467:android:e953204975e38f531bc2f6',
    messagingSenderId: '775519398467',
    projectId: 'reencontrapp',
    storageBucket: 'reencontrapp.firebasestorage.app',
  );
}
