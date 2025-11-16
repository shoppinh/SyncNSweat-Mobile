import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  AppConfig({
    required this.apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 20),
  });

  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  static Future<AppConfig> load() async {
    const dartDefineBase = String.fromEnvironment('API_BASE_URL');
    final baseUrl = dartDefineBase.isNotEmpty
        ? dartDefineBase
        : (kReleaseMode ? 'https://api.syncnsweat.com/api/v1' : 'http://localhost:8000/api/v1');

    return AppConfig(apiBaseUrl: baseUrl);
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig not loaded');
});
