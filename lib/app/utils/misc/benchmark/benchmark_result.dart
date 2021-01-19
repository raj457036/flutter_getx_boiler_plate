import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BenchmarkResult<V> extends Equatable {
  final Duration duration;
  final V result;

  BenchmarkResult({
    @required this.duration,
    @required this.result,
  });

  @override
  List<Object> get props => [duration, result];

  @override
  bool get stringify => true;
}
