import 'dart:io';

import 'package:http/io_client.dart';

import 'ssl_pinning.dart';

// A secure HTTP client that uses SSL pinning
// by wrapping [HttpClient] with pinned certificate.
class SecureHttpClient extends IOClient {
  SecureHttpClient._(HttpClient client) : super(client);

  // Provides a singleton instance of [SecureHttpClient]
  // with SSL pinning applied.
  static Future<SecureHttpClient> getInstance() async {
    final client = await createSecureHttpClient();
    return SecureHttpClient._(client);
  }
}
