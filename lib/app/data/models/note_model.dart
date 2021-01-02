import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:boiler_plate/app/global/storage/storage.dart';

class NoteModel extends DbBinder<NoteModel> with EquatableMixin {
  final String uuid;
  final String title;
  final String body;
  final DateTime timestamp;

  NoteModel({
    int id,
    this.uuid,
    this.title,
    this.body,
    this.timestamp,
  }) : super(id: id);

  NoteModel copyWith({
    String uuid,
    String title,
    String body,
    DateTime timestamp,
  }) {
    return NoteModel(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'body': body,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NoteModel(
      id: map["__id"],
      uuid: map['uuid'],
      title: map['title'],
      body: map['body'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [pk, uuid, title, body, timestamp];

  @override
  fromMap(Map<String, dynamic> map) {
    return NoteModel.fromMap(map);
  }
}
