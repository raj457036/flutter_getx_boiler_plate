import '../../core/core.dart';

class TestRepository extends BaseRepository {
  Future<Either<Failure, void>> someMethod() async {
    try {
      // call to provider
      return Right(null);
    } catch (e) {
      return handleException(e);
    }
  }
}
