import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByApVefX0I4JsVfP_QmZjMTInGqrC8ofY',
    appId: '1:519879800412:android:05fe66dd8a62f6bdef1899"',
    messagingSenderId: '519879800412',
    projectId: 'chatgpt-7b3c4',
    storageBucket: 'chatgpt-7b3c4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkZf5P7mj_Mpm4rx7VkEWyFvnwD3hnCfs',
    appId: '1:519879800412:ios:f23c4b260a5c1a36ef1899',
    messagingSenderId: '519879800412',
    projectId: 'chatgpt-7b3c4',
    storageBucket: 'chatgpt-7b3c4.appspot.com',
    iosClientId:
        '519879800412-6ti1ijjocl08rie5k07rbjrte3h7jqpj.apps.googleusercontent.com',
    androidClientId:
        "519879800412-6r3l8mlmom4r2s681pjk965fiqk1mtdb.apps.googleusercontent.com",
    iosBundleId: 'com.thatsend.talkai',
  );
}
