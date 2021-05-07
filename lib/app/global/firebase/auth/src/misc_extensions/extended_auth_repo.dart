import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../../generated/locales.g.dart';
import '../../../../../core/core.dart';
import 'extended_auth_failures.dart';
import 'firebase_failures.dart';

abstract class FirebaseAuthExtendedRepo extends BaseRepository {
  @override
  Either<Failure, T> handleException<T>(e) {
    if (e is FirebaseException) {
      Failure failure;
      switch (e.code) {
        case "user-disabled":
          failure = FirebaseInvalidEmailFailure(
            e,
            LocaleKeys.firebase_user_disabled.tr,
          );
          break;
        case "user-not-found":
          failure = FirebaseInvalidEmailFailure(
            e,
            LocaleKeys.firebase_user_not_found.tr,
          );
          break;
        case "wrong-password":
          failure = FirebaseInvalidEmailFailure(
            e,
            LocaleKeys.firebase_wrong_password.tr,
          );
          break;
        case "account-exists-with-different-credential":
          failure = FirebaseAccountExistsWithDifferentCredFailure(
            e,
            LocaleKeys.firebase_account_exists_with_different_credential.tr,
          );
          break;
        case "invalid-credential":
          failure = FirebaseInvalidCredFailure(
            e,
            LocaleKeys.firebase_invalid_credential.tr,
          );
          break;
        case "invalid-verification-code":
          failure = FirebaseInvalidVerificationCodeFailure(
            e,
            LocaleKeys.firebase_invalid_verification_code.tr,
          );
          break;
        case "invalid-verification-id":
          failure = FirebaseInvalidVerificationIdFailure(
            e,
            LocaleKeys.firebase_invalid_verification_id.tr,
          );
          break;
        default:
          failure = FirebaseFailure(e, LocaleKeys.firebase_failure.tr);
      }
      return Left(failure);
    }
    return super.handleException(e);
  }
}
