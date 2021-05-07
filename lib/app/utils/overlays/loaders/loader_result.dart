import 'package:equatable/equatable.dart';

class LoaderResult<V> extends Equatable {
  final bool timeout;
  final String? tag;
  final V result;
  final Duration timetaken;

  LoaderResult(this.timeout, this.tag, this.result, this.timetaken);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [timeout, tag, result, timetaken];
}
