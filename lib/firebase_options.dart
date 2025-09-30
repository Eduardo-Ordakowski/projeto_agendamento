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
        return windows;
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
    apiKey: 'AIzaSyD6kKNpu82_6xhWNRTWQ5veUXBMD5dQA7g',
    appId: '1:241454201811:web:de1f6de74c417eeddfcd26',
    messagingSenderId: '241454201811',
    projectId: 'projeto-agendamento-dee01',
    authDomain: 'projeto-agendamento-dee01.firebaseapp.com',
    storageBucket: 'projeto-agendamento-dee01.firebasestorage.app',
    measurementId: 'G-KD9XV8HJ4E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_QVwbGzuskdjceH5o-mSzQk-LaLeDiVs',
    appId: '1:241454201811:android:d3ba217862d1419ddfcd26',
    messagingSenderId: '241454201811',
    projectId: 'projeto-agendamento-dee01',
    storageBucket: 'projeto-agendamento-dee01.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmnODCa63QUE49X0KrbuY7EwcqoaCOlwM',
    appId: '1:241454201811:ios:0073d615c939ca5fdfcd26',
    messagingSenderId: '241454201811',
    projectId: 'projeto-agendamento-dee01',
    storageBucket: 'projeto-agendamento-dee01.firebasestorage.app',
    iosClientId: '241454201811-eahhrrs6ghqa0je4hlrnvc6npcvdngik.apps.googleusercontent.com',
    iosBundleId: 'com.example.projetoAgendamento',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmnODCa63QUE49X0KrbuY7EwcqoaCOlwM',
    appId: '1:241454201811:ios:0073d615c939ca5fdfcd26',
    messagingSenderId: '241454201811',
    projectId: 'projeto-agendamento-dee01',
    storageBucket: 'projeto-agendamento-dee01.firebasestorage.app',
    iosClientId: '241454201811-eahhrrs6ghqa0je4hlrnvc6npcvdngik.apps.googleusercontent.com',
    iosBundleId: 'com.example.projetoAgendamento',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6kKNpu82_6xhWNRTWQ5veUXBMD5dQA7g',
    appId: '1:241454201811:web:b71bdb16da8b667cdfcd26',
    messagingSenderId: '241454201811',
    projectId: 'projeto-agendamento-dee01',
    authDomain: 'projeto-agendamento-dee01.firebaseapp.com',
    storageBucket: 'projeto-agendamento-dee01.firebasestorage.app',
    measurementId: 'G-7C82NFZ5DN',
  );
}
