import '../types.dart';
import 'benchmark_result.dart';

Future<BenchmarkResult<V>> runBenchmark<V>(AsyncTask<V> asyncTask) async {
  final start = DateTime.now();
  final result = await asyncTask();
  final end = DateTime.now();
  return BenchmarkResult(duration: end.difference(start), result: result);
}
