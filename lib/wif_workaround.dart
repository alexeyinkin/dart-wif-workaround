import 'dart:io';

import 'package:googleapis_auth/auth_io.dart' as ga;
import 'package:http/http.dart' as http;

/// Creates an authenticated client with application default credentials.
///
/// First, attempts to call the function
/// [ga.clientViaApplicationDefaultCredentials] from googleapis_auth.
/// If it fails, calls `gcloud auth print-access-token` to get an access token
/// and returns a client which uses that token.
Future<ga.AuthClient> clientViaApplicationDefaultCredentials({
  required List<String> scopes,
  http.Client? baseClient,
}) async {
  try {
    return await ga.clientViaApplicationDefaultCredentials(
      scopes: scopes,
      baseClient: baseClient,
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (ex) {
    print(ex); // ignore: avoid_print
    return _getWorkloadIdentityFederationClient(
      scopes: scopes,
      baseClient: baseClient,
    );
  }
}

Future<ga.AuthClient> _getWorkloadIdentityFederationClient({
  required List<String> scopes,
  required http.Client? baseClient,
}) async {
  final process = await Process.run('gcloud', ['auth', 'print-access-token']);

  if (process.exitCode != 0) {
    throw Exception(
      'Command failed with exit code ${process.exitCode}: ${process.stderr}',
    );
  }

  final accessToken = process.stdout as String;

  final accessTokenTrimmed = accessToken.trimRight();

  return ga.authenticatedClient(
    baseClient ?? http.Client(),
    ga.AccessCredentials(
      ga.AccessToken(
        'Bearer',
        accessTokenTrimmed,
        DateTime.now().add(const Duration(hours: 1)).toUtc(),
      ),
      null,
      scopes,
    ),
  );
}
