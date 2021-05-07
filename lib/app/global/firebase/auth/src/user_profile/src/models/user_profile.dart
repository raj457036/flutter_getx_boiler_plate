import 'dart:convert';

import 'package:equatable/equatable.dart';

// TODO 1 : UPDATE THIS MODEL ACCODING TO THE NEED

class UserProfile with EquatableMixin {
  final String? id;
  final String? uid;

  UserProfile({
    required this.id,
    required this.uid,
  });

  UserProfile copyWith({
    String? id,
    String? uuid,
  }) {
    return UserProfile(
      id: id ?? this.id,
      uid: uuid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uid,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      uid: map['uuid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, uid];
}
