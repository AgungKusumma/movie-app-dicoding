import 'dart:io';

import 'package:flutter/services.dart';

// Loads and applies SSL certificate for HTTP client.
// This ensures that only the specified certificate is trusted.
Future<HttpClient> createSecureHttpClient() async {
  // Load SSL certificate from the assets
  final sslCert = await rootBundle.load('certificates/cert.pem');

  // Create a SecurityContext without using trusted roots
  final context = SecurityContext(withTrustedRoots: false);

  // Set trusted certificate from the loaded bytes
  context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

  // Return the HttpClient configured with the custom context
  return HttpClient(context: context);
}
