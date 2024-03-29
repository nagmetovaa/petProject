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
    apiKey: 'AIzaSyDq27Yh4Xhn5y59U8JIdP07x7bgdFA6Vlw',
    appId: '1:856490422086:web:b4c66bac37f20d056e7f47',
    messagingSenderId: '856490422086',
    projectId: 'evaluationappflutter',
    authDomain: 'evaluationappflutter.firebaseapp.com',
    storageBucket: 'evaluationappflutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2slhPH0GRTqSGQZwXbQFnxJwRS0jttZg',
    appId: '1:856490422086:android:3add5fffa6b325266e7f47',
    messagingSenderId: '856490422086',
    projectId: 'evaluationappflutter',
    storageBucket: 'evaluationappflutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZw0lsyoFAvFxi2MAQ5P2osp-BR8nschc',
    appId: '1:856490422086:ios:4501166baa437e3e6e7f47',
    messagingSenderId: '856490422086',
    projectId: 'evaluationappflutter',
    storageBucket: 'evaluationappflutter.appspot.com',
    iosBundleId: 'anar.nagmet.myapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZw0lsyoFAvFxi2MAQ5P2osp-BR8nschc',
    appId: '1:856490422086:ios:2f4281b66ece4d366e7f47',
    messagingSenderId: '856490422086',
    projectId: 'evaluationappflutter',
    storageBucket: 'evaluationappflutter.appspot.com',
    iosBundleId: 'anar.nagmet.myapp.RunnerTests',
  );
}
