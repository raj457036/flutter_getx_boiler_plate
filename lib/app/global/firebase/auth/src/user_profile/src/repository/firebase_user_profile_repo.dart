import 'package:get/get.dart';

import '../../../../../../../core/core.dart';
import '../../../../firebase_auth_controller.dart';
import '../models/user_profile.dart';
import '../provider/firebase_user_profile_provider.dart';

class FirebaseUserProfileRepository extends BaseRepository {
  final FirebaseAuthController _authController =
      Get.find<FirebaseAuthController>();

  final FirebaseUserProfileProvider _profileProvider =
      Get.find<FirebaseUserProfileProvider>();

  Future<Either<Failure, UserProfile?>> getUser() async {
    try {
      final uid = _authController.firebaseUser?.uid;

      if (uid == null) return Right(null);
      final _user = await _profileProvider.getUser(uid);
      return Right(_user);
    } catch (e) {
      return handleException(e);
    }
  }

  Future<Either<Failure, UserProfile>> updateProfile(
      UserProfile updatedProfile) async {
    try {
      final _user = await _profileProvider.updateProfile(updatedProfile);
      return Right(_user);
    } catch (e) {
      return handleException(e);
    }
  }

  Future<Either<Failure, bool>> deleteProfile() async {
    try {
      final uid = _authController.firebaseUser?.uid;

      if (uid == null) return Right(false);
      final _user = await _profileProvider.deleteProfile(uid);
      return Right(_user);
    } catch (e) {
      return handleException(e);
    }
  }

  Future<Either<Failure, void>> deleteProfileWithId(String docId) async {
    try {
      final _result = await _profileProvider.deleteProfileWithDocId(docId);
      return Right(_result);
    } catch (e) {
      return handleException(e);
    }
  }

  Future<Either<Failure, UserProfile>> createProfile(
      UserProfile newProfile) async {
    try {
      final _result = await _profileProvider.createProfile(newProfile);
      return Right(_result);
    } catch (e) {
      return handleException(e);
    }
  }
}
