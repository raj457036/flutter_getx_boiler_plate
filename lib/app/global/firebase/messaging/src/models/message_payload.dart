import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

import 'executor_message.dart';
import 'notification_message_payload.dart';

class MessagePayload extends Equatable {
  final NotificationMessagePayload notification;
  final ExecutorMessagePayload executorPayload;
  final Map<String, dynamic> dataPayload;

  MessagePayload({
    @required this.notification,
    @required this.executorPayload,
    @required this.dataPayload,
  });

  MessagePayload copyWith({
    NotificationMessagePayload notification,
    ExecutorMessagePayload executorPayload,
    Map<String, dynamic> dataPayload,
  }) {
    return MessagePayload(
      notification: notification ?? this.notification,
      executorPayload: executorPayload ?? this.executorPayload,
      dataPayload: dataPayload ?? this.dataPayload,
    );
  }

  Map<String, dynamic> toMap() {
    final executor = executorPayload?.toMap();
    executor?.removeWhere((key, value) => value == null);

    dataPayload?.removeWhere((key, value) => value == null);

    final data = <String, dynamic>{};

    if (executor?.isNotEmpty ?? false) data['executor'] = executor;
    if (dataPayload?.isNotEmpty ?? false) data['payload'] = dataPayload;

    final message = <String, dynamic>{
      'notification': notification?.toMap(),
      'data': data,
    };

    message.removeWhere((key, value) => value == null || value.isEmpty);

    return message;
  }

  factory MessagePayload.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    final parsedMsg = MessagePayload(
      notification:
          NotificationMessagePayload.fromMap(map['notification']) ?? null,
      executorPayload: ExecutorMessagePayload.fromMap(map['data']) ?? null,
      dataPayload: Map<String, dynamic>.from(map['data'] ?? const {}),
    );

    parsedMsg._clean();
    return parsedMsg;
  }

  factory MessagePayload.fromRemoteMessage(RemoteMessage message) {
    final parsedMsg = MessagePayload(
      notification: message.notification != null
          ? NotificationMessagePayload(
              body: message.notification.body,
              title: message.notification.title,
            )
          : null,
      executorPayload: ExecutorMessagePayload.fromMap(
            message.data ?? const <String, dynamic>{},
          ) ??
          null,
      dataPayload: Map<String, dynamic>.from(
        message.data ?? const <String, dynamic>{},
      ),
    );

    parsedMsg._clean();
    return parsedMsg;
  }

  _clean() {
    final _keys = executorPayload.toMap().keys;

    for (var key in _keys) {
      dataPayload.remove(key);
    }
  }

  String toJson() => json.encode(toMap());

  factory MessagePayload.fromJson(String source) =>
      MessagePayload.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [notification, executorPayload, dataPayload];
}
