// Generate hash for missionID
import 'dart:convert';
import 'dart:math';

class Helper {
  static String generateHash(int length) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
}
