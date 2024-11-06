import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Adds hash functionality to our String id
extension HashStringExtension on String {
  /// Returns the SHA256
  String get hashValue {
    return sha256.convert(utf8.encode(this)).toString();
  }
}
