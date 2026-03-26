import 'package:flutter/foundation.dart';

class AppConstants {
  static const bool useFakeApi = bool.fromEnvironment(
    'EMUN_USE_FAKE_API',
    defaultValue: false,
  );
  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'EMUN_API_BASE_URL',
    defaultValue: '',
  );

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _apiBaseUrlOverride;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://127.0.0.1:8000/api/v1';
  }

  static const String fakeBaseUrl = 'https://fake.emun.app/api';
  static const Duration fakeApiDelay = Duration(milliseconds: 600);
  static const String currency = 'ETB';
}
