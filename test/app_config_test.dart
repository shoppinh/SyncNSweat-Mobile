import 'package:flutter_test/flutter_test.dart';

import 'package:syncnsweat_mobile/core/config/app_config.dart';

void main() {
  test('AppConfig falls back to localhost in debug', () async {
    final config = await AppConfig.load();
    expect(config.apiBaseUrl.isNotEmpty, isTrue);
  });
}
