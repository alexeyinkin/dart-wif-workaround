import 'package:gcloud/pubsub.dart';
import 'package:wif_workaround/wif_workaround.dart' as w;

Future<void> main() async {
  final pubsub = PubSub(
    // Add 'w.' before your normal call.
    await w.clientViaApplicationDefaultCredentials(scopes: PubSub.SCOPES),
    'my-project-id',
  );

  // ...
}
