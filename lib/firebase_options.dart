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
    apiKey: 'AIzaSyD90dhNnl79uO0_5qX6pvlWOPULZZE6woA',
    appId: '1:886289283374:web:0da8728684b65e90d562bf',
    messagingSenderId: '886289283374',
    projectId: 'messager-dc804',
    authDomain: 'messager-dc804.firebaseapp.com',
    storageBucket: 'messager-dc804.appspot.com',
    measurementId: 'G-QWEH21ZPWX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiX8prbzGxUs9loRa-EVnKPnjywhp3dg4',
    appId: '1:886289283374:android:42e21ae08a31a3ded562bf',
    messagingSenderId: '886289283374',
    projectId: 'messager-dc804',
    storageBucket: 'messager-dc804.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXyLYRExRVyVJB-Nb788Ve3orq-TOBUjI',
    appId: '1:886289283374:ios:f95ea00ae1c89d1dd562bf',
    messagingSenderId: '886289283374',
    projectId: 'messager-dc804',
    storageBucket: 'messager-dc804.appspot.com',
    iosClientId: '886289283374-5314bbsevmnqtm7cq24nqre3d4bv1v7g.apps.googleusercontent.com',
    iosBundleId: 'com.messager.messager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXyLYRExRVyVJB-Nb788Ve3orq-TOBUjI',
    appId: '1:886289283374:ios:b2df933e3beac983d562bf',
    messagingSenderId: '886289283374',
    projectId: 'messager-dc804',
    storageBucket: 'messager-dc804.appspot.com',
    iosClientId: '886289283374-7spnefmejd6o8cg8h46iv5locsbk43uj.apps.googleusercontent.com',
    iosBundleId: 'com.messager.messager.RunnerTests',
  );
}
