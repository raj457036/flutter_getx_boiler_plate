import 'dart:convert';

import 'package:equatable/equatable.dart';

class NotificationMessagePayload extends Equatable {
  final String? title;
  final String? body;

  NotificationMessagePayload({
    required this.title,
    required this.body,
  });

  NotificationMessagePayload copyWith({
    String? title,
    String? body,
  }) {
    return NotificationMessagePayload(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  factory NotificationMessagePayload.fromMap(Map<String, dynamic> map) {
    return NotificationMessagePayload(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMessagePayload.fromJson(String source) =>
      NotificationMessagePayload.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [title, body];
}
