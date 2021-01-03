import '../../core/core.dart';
import '../function/either.dart';

abstract class BaseRepository {
  Either<Failure, dynamic> handleException(e) {
    final FailureCallback failureCallback =
        EXCEPTION_FAILURE_MAP[e.runtimeType];

    if (failureCallback != null) return Left(failureCallback(e));
    return Left(BaseGeneralFailure());
  }
}
