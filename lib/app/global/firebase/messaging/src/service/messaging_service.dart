import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../../../../core/logger/logger.dart';
import '../../task_mapper.dart';
import '../models/message_payload.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  final payload = MessagePayload.fromRemoteMessage(message);
  final executor = payload.executorPayload;

  if (executor?.isExpired ?? false) return;
  if (executor?.onlyBackground ?? false) return;
  if (executor?.onlyOnTap ?? false) return;

  await _taskExecutor(payload);
}

Future<void> _taskExecutor(MessagePayload payload) async {
  final executorPayload = payload.executorPayload;

  final callback = executorPayload?.callback;

  final executor = TASK_MAPPER[callback];

  if (executor == null) return;

  try {
    await executor().run(payload);
  } catch (e) {
    LogService.error("ERROR WHILE RUNNING TASK: $callback reason $e");
  }
}

class MessagingService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // RX
  final Rx<NotificationSettings?> activeSettings =
      Rx<NotificationSettings?>(null);

  // Getters
  NotificationSettings? get settings => activeSettings.value;

  @override
  void onInit() {
    // TODO 4 : CONFIGURE MESSAGING PRESENTATION OPTIONS
    _messaging.setForegroundNotificationPresentationOptions(
      badge: true,
      alert: true,
      sound: true,
    );
    super.onInit();
  }

  @override
  void onReady() {
    _configureMessaging();
    _onLaunch();
    super.onReady();
  }

  @override
  void onClose() {}

  _configureMessaging() {
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
  }

  Future<AuthorizationStatus?> requestNotificationPermissions() async {
    // TODO 5 : CONFIGURE MESSAGING PERMISSIONS
    activeSettings.value = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return activeSettings.value?.authorizationStatus;
  }

  _onMessage(RemoteMessage message) {
    final payload = MessagePayload.fromRemoteMessage(message);
    final executor = payload.executorPayload;

    if (executor?.isExpired ?? false) return;
    if (executor?.onlyBackground ?? false) return;
    if (executor?.onlyOnTap ?? false) return;

    _taskExecutor(payload);
  }

  _onResume(RemoteMessage message) {
    final payload = MessagePayload.fromRemoteMessage(message);
    final executor = payload.executorPayload;
    if (executor?.isExpired ?? false) return;
    if (executor?.onlyBackground ?? false) return;
    if (!(executor?.onlyOnTap ?? false)) return;

    _taskExecutor(payload);
  }

  _onLaunch() async {
    final RemoteMessage? _message = await _messaging.getInitialMessage();
    if (_message == null) return;

    final payload = MessagePayload.fromRemoteMessage(_message);
    final executor = payload.executorPayload;

    if (executor?.isExpired ?? false) return;
    if (executor?.onlyBackground ?? false) return;
    if (executor?.onlyOnTap ?? false) return;

    await _taskExecutor(payload);
  }
}
