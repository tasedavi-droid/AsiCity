// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      default:
        throw UnsupportedError(
          'FirebaseOptions não configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAw-0I37eHbB5oh1xQitoXqJhZAALzKQm0',
    appId: '1:358270623507:android:7e60b0ac18b00f1e8144e6',
    messagingSenderId: '358270623507',
    projectId: 'asicity',
    storageBucket: 'asicity.firebasestorage.app',
  );
}
