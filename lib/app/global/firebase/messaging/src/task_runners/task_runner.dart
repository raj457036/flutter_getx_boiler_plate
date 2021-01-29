import '../models/message_payload.dart';

abstract class TaskRunner {
  Future<void> run(MessagePayload payload);
}
