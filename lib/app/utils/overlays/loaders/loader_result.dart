import 'package:equatable/equatable.dart';

import '../../../core/core.dart';

class LoaderResult<V> extends Equatable {
  final bool timeout;
  final String? tag;
  final V result;
  final Duration timetaken;
  final Failure? failure;

  LoaderResult(
    this.timeout,
    this.tag,
    this.result,
    this.timetaken, {
    this.failure,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [timeout, tag, result, timetaken];
}
