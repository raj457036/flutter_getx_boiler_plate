import 'package:meta/meta.dart';

class FirebaseModule {
  final String Function(int code) getFailureMessage;

  FirebaseModule({
    @required this.getFailureMessage,
  });
}
