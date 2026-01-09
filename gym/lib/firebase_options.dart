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
    apiKey: 'AIzaSyAxj7XDDgQEoX_hf7OFTKqdUK0ZSVLceDQ',
    appId: '1:15147748415:web:c31016c979ef525a2c7c8a',
    messagingSenderId: '15147748415',
    projectId: 'thatsendfitness',
    authDomain: 'thatsendfitness.firebaseapp.com',
    storageBucket: 'thatsendfitness.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpYqq1gaQ8iTQAjec6GzV0KEprANFlzyY',
    appId: '1:15147748415:android:acf2739b3898e9692c7c8a',
    messagingSenderId: '15147748415',
    projectId: 'thatsendfitness',
    storageBucket: 'thatsendfitness.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCj_Ks_UccY8T6bJKYyds67l4YgCpg_Es',
    appId: '1:15147748415:ios:ed8c2fc89608539e2c7c8a',
    messagingSenderId: '15147748415',
    projectId: 'thatsendfitness',
    storageBucket: 'thatsendfitness.appspot.com',
    iosClientId:
        '15147748415-idb774ibnkb2n341s0n9vu7bh2agc4id.apps.googleusercontent.com',
    iosBundleId: 'com.thatsend.graceFitness',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCj_Ks_UccY8T6bJKYyds67l4YgCpg_Es',
    appId: '1:15147748415:ios:ed8c2fc89608539e2c7c8a',
    messagingSenderId: '15147748415',
    projectId: 'thatsendfitness',
    storageBucket: 'thatsendfitness.appspot.com',
    iosClientId:
        '15147748415-t35pfpn3ero8ld15atd6sb71gt12ri42.apps.googleusercontent.com',
    iosBundleId: 'com.thatsend.graceFitness',
  );
}
