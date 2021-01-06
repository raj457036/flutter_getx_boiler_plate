import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  String toJson();
  Map<String, dynamic> toMap();
}
