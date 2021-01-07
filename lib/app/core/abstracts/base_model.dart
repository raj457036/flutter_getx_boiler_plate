import 'package:equatable/equatable.dart';

abstract class BaseModel<T extends BaseModel<T>> extends Equatable {
  String toJson();
  Map<String, dynamic> toMap();
  T copyWith();

  @override
  bool get stringify => true;
}
