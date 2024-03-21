# wif_workaround

You normally use [googleapis_auth](https://pub.dev/packages/googleapis_auth)
package to connect to Google Cloud services.
It works with service account keys and [metadata server](https://cloud.google.com/compute/docs/metadata/overview),
but not with local keys obtained with
[Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation).
See [this issue](https://github.com/google/googleapis.dart/issues/606).

This package allows you to use Workload Identity Federation
if you have locally installed [gcloud CLI](https://cloud.google.com/sdk/gcloud).

It wraps the function
[clientViaApplicationDefaultCredentials](https://pub.dev/documentation/googleapis_auth/latest/auth_io/clientViaApplicationDefaultCredentials.html)
which you normally call to authenticate and which breaks with WIF keys.
On any exception, it executes `gcloud auth print-access-token` to get an access token
and returns a client which adds it to requests.

## Usage

Modify your normal code by adding the import and 'w.' prefix:

```dart
import 'package:gcloud/pubsub.dart';
import 'package:wif_workaround/wif_workaround.dart' as w; // Add this import.

Future<void> main() async {
  final pubsub = PubSub(
    // Add 'w.' before your normal call.
    await w.clientViaApplicationDefaultCredentials(scopes: PubSub.SCOPES),
    'my-project-id',
  );

  // ...
}
```
