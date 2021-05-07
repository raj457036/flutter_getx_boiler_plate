import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../global/storage/storage.dart';

class UserModel extends DbBinder<UserModel> with EquatableMixin {
  final String? name;
  final String? uuid;
  final String? phone;
  final DateTime? dob;
  final bool? isAdmin;

  UserModel({
    int id = -1,
    this.name,
    this.uuid,
    this.phone,
    this.dob,
    this.isAdmin,
  }) : super(id: id);

  UserModel copyWith({
    String? name,
    String? uuid,
    String? phone,
    DateTime? dob,
    bool? isAdmin,
  }) {
    return UserModel(
      name: name ?? this.name,
      uuid: uuid ?? this.uuid,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uuid': uuid,
      'phone': phone,
      'dob': dob?.millisecondsSinceEpoch,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['__id'],
      name: map['name'],
      uuid: map['uuid'],
      phone: map['phone'],
      dob: getDbDate(map['dob']),
      isAdmin: getDbBool(map['isAdmin']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $pk, name: $name, uuid: $uuid, phone: $phone, dob: $dob, isAdmin: $isAdmin)';
  }

  @override
  UserModel fromMap(Map<String, dynamic>? map) {
    if (map == null) return UserModel();
    return UserModel.fromMap(map);
  }

  @override
  List<Object?> get props => [pk, uuid, name, phone, dob, isAdmin];
}
