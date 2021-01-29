import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ExecutorMessagePayload extends Equatable {
  final bool onlyBackground;
  final bool onlyForeground;
  final bool onlyOnTap;
  final String callback;
  final Duration timeout;
  final int timestamp;

  ExecutorMessagePayload({
    @required this.onlyBackground,
    @required this.onlyForeground,
    @required this.onlyOnTap,
    @required this.callback,
    @required this.timeout,
  }) : timestamp = DateTime.now().millisecondsSinceEpoch;

  ExecutorMessagePayload copyWith({
    bool onlyBackground,
    bool onlyForeground,
    bool onlyOnTap,
    String callback,
    Duration timeout,
  }) {
    return ExecutorMessagePayload(
      onlyBackground: onlyBackground ?? this.onlyBackground,
      onlyForeground: onlyForeground ?? this.onlyForeground,
      onlyOnTap: onlyOnTap ?? this.onlyOnTap,
      callback: callback ?? this.callback,
      timeout: timeout ?? this.timeout,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'onlyBackground': onlyBackground,
      'onlyForeground': onlyForeground,
      'onlyOnTap': onlyOnTap,
      'callback': callback,
      'timeout': timeout?.inSeconds,
      'timestamp': timestamp,
    };
  }

  factory ExecutorMessagePayload.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ExecutorMessagePayload(
      onlyBackground: map['onlyBackground'] ?? false,
      onlyForeground: map['onlyForeground'] ?? false,
      onlyOnTap: map['onlyOnTap'] ?? false,
      callback: map['callback'] ?? '',
      timeout: Duration(seconds: map['timeout'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExecutorMessagePayload.fromJson(String source) =>
      ExecutorMessagePayload.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      onlyBackground,
      onlyForeground,
      onlyOnTap,
      callback,
      timeout,
      timestamp,
    ];
  }

  bool get isExpired {
    final now = DateTime.now();
    final withTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final addedTimeout = withTimestamp.add(timeout);
    return addedTimeout.isBefore(now);
  }
}
