final class Env {
  // Android
  static const String androidApiKey = String.fromEnvironment('ANDROID_API_KEY');
  static const String androidAppId = String.fromEnvironment('ANDROID_APP_ID');
  static const String androidMesssagingSenderId = String.fromEnvironment(
    'ANDROID_MESSAGING_SENDER_ID',
  );
  static const String androidProjectId = String.fromEnvironment(
    'ANDROID_PROJECT_ID',
  );
  static const String androidStorageBucket = String.fromEnvironment(
    'ANDROID_STORAGE_BUCKET',
  );

  // iOS
  static const String iosApiKey = String.fromEnvironment('IOS_API_KEY');
  static const String iosAppId = String.fromEnvironment('IOS_APP_ID');
  static const String iosMesssagingSenderId = String.fromEnvironment(
    'IOS_MESSAGING_SENDER_ID',
  );
  static const String iosProjectId = String.fromEnvironment('IOS_PROJECT_ID');
  static const String iosStorageBucket = String.fromEnvironment(
    'IOS_STORAGE_BUCKET',
  );
  static const String androidClientId = String.fromEnvironment(
    'ANDROID_CLIENT_ID',
  );
  static const String iosClientId = String.fromEnvironment('IOS_CLIENT_ID');
  static const String iosBundleId = String.fromEnvironment('IOS_BUNDLE_ID');
}
