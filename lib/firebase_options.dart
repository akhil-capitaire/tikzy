import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase options for web platform
const FirebaseOptions firebaseWebOptions = FirebaseOptions(
  apiKey: 'AIzaSyAdP9sONNBaPJF1Jdr4QgnlqSgFlfhQG1k',
  authDomain: 'tickzy-8f3ef.firebaseapp.com',
  projectId: 'tickzy-8f3ef',
  storageBucket: 'tickzy-8f3ef.appspot.com',
  messagingSenderId: '353510236220',
  appId: '1:353510236220:web:ee1518b280c45e67bbe339',
  measurementId: 'G-RT8L04BHFC',
);

/// Firebase options for Android platform
const FirebaseOptions firebaseAndroidOptions = FirebaseOptions(
  apiKey: 'AIzaSyAdP9sONNBaPJF1Jdr4QgnlqSgFlfhQG1k',
  appId: '1:353510236220:android:f510b7e1842c27ccbbe339',
  messagingSenderId: '353510236220',
  projectId: 'tickzy-8f3ef',
  storageBucket: 'tickzy-8f3ef.appspot.com',
);

/// Firebase options for iOS platform
const FirebaseOptions firebaseIOSOptions = FirebaseOptions(
  apiKey: 'AIzaSyDCpXFgSm4RrTrTbVx7f9X9HfNv616GHx4',
  appId: '1:776236497434:ios:9803134fc154ee1040afa3',
  messagingSenderId: '776236497434',
  projectId: 'pravasitax-e11e3',
  storageBucket: 'pravasitax-e11e3.firebasestorage.app',
  iosClientId: '1:776236497434:ios:9803134fc154ee1040afa3',
  iosBundleId: 'com.capitaire.pravasitax',
);

/// Firebase options for macOS (if needed)
const FirebaseOptions firebaseMacOSOptions = FirebaseOptions(
  apiKey: 'YOUR_MACOS_API_KEY',
  appId: 'YOUR_MACOS_APP_ID',
  messagingSenderId: 'YOUR_MACOS_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_STORAGE_BUCKET',
  iosClientId: 'YOUR_MACOS_CLIENT_ID',
  iosBundleId: 'YOUR_MACOS_BUNDLE_ID',
);

class DefaultFirebaseOptions {
  /// Returns appropriate FirebaseOptions based on platform
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return firebaseWebOptions;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return firebaseAndroidOptions;
      case TargetPlatform.iOS:
        return firebaseIOSOptions;
      case TargetPlatform.macOS:
        return firebaseMacOSOptions;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'FirebaseOptions not configured for this platform.',
        );
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }
}
