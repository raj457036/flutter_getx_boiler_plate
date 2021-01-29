import '../../models/message_payload.dart';
import '../task_runner.dart';

class MessagePrinter extends TaskRunner {
  @override
  Future<void> run(MessagePayload payload) async {
    print("Payload Received: $payload");
  }
}
