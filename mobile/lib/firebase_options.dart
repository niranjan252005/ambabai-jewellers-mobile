import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAEu2JLb26kR7tYZ3TgbTmVsWhMEFa7yzk',
    appId: '1:921451130462:web:058735c6244e8db6a24ecf',
    messagingSenderId: '921451130462',
    projectId: 'ambabai-jewellers',
    authDomain: 'ambabai-jewellers.firebaseapp.com',
    storageBucket: 'ambabai-jewellers.firebasestorage.app',
    measurementId: 'G-Q9NGY50ZLT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEu2JLb26kR7tYZ3TgbTmVsWhMEFa7yzk',
    appId: '1:921451130462:android:058735c6244e8db6a24ecf',
    messagingSenderId: '921451130462',
    projectId: 'ambabai-jewellers',
    storageBucket: 'ambabai-jewellers.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEu2JLb26kR7tYZ3TgbTmVsWhMEFa7yzk',
    appId: '1:921451130462:ios:058735c6244e8db6a24ecf',
    messagingSenderId: '921451130462',
    projectId: 'ambabai-jewellers',
    storageBucket: 'ambabai-jewellers.firebasestorage.app',
  );
}
