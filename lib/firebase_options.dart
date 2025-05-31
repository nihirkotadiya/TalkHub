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

  static const FirebaseOptions web = FirebaseOptions(
     apiKey: "AIzaSyBcRJLBNtgQ_EV04mXW5VzqGmuv3zmkQTQ",
  authDomain: "talkhub-d5b1e.firebaseapp.com",
  projectId: "talkhub-d5b1e",
  storageBucket: "talkhub-d5b1e.firebasestorage.app",
  messagingSenderId: "273857954256",
  appId: "1:273857954256:web:63c18885abe87a836279d5"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAheAl1ApAG3f7-13zVCXoVTho4_CNl9wA',
    appId: '1:273857954256:android:98ed8b9594417d366279d5',
    messagingSenderId: '273857954256',
    projectId: 'talkhub-d5b1e',
    storageBucket: 'talkhub-d5b1e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAheAl1ApAG3f7-13zVCXoVTho4_CNl9wA',
    appId: '1:273857954256:android:98ed8b9594417d366279d5',
    messagingSenderId: '273857954256',
    projectId: 'talkhub-d5b1e',
    storageBucket: 'talkhub-d5b1e.firebasestorage.app',
    iosBundleId: 'com.example.zoomClone',
  );
}
