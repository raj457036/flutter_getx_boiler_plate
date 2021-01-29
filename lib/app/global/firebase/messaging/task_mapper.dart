import 'src/task_runners/runners/message_printer.dart';
import 'src/task_runners/task_runner.dart';

typedef TaskRunner TaskFetcher();

// TODO: ASSIGN TASKS/CALLBACK KEYS WITH ACTUAL STATIC METHODS/FUNCTIONS

// ignore: non_constant_identifier_names
final TASK_MAPPER = <String, TaskFetcher>{
  // sample task
  "message-printer": () => MessagePrinter(),
};
