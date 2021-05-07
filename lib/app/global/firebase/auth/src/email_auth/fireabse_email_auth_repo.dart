import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../../generated/locales.g.dart';
import '../../../../../core/core.dart';
import '../../firebase_auth_controller.dart';
import '../misc_extensions/firebase_failures.dart';

class FireabaseEmailAuthRepository extends BaseRepository {
  final FirebaseAuthController _controller = Get.find<FirebaseAuthController>();

  FirebaseAuth get auth => _controller.auth;

  ///Asynchronously creates and becomes an anonymous user.
  ///
  ///If there is already an anonymous user signed in, that user will be returned instead.
  ///If there is any other existing user signed in, that user will be signed out.
  ///
  ///**Important** : You must enable Anonymous accounts in the Auth section
  ///of the Firebase console before being able to use them.
  Future<Either<Failure, UserCredential>> signInAnonymously() async {
    try {
      final result = await auth.signInAnonymously();
      return Right(result);
    } on FirebaseException catch (e) {
      Failure failure;
      switch (e.code) {
        case "operation-not-allowed":
          failure = FirebaseOperationNotAllowedFailure(
            e,
            LocaleKeys.firebase_operation_not_allowed.tr,
          );
          break;
        default:
          failure = FirebaseFailure(e, LocaleKeys.firebase_failure.tr);
      }

      return Left(failure);
    } catch (e) {
      return handleException(e);
    }
  }

  ///Attempts to sign in a user with the given email address and password.
  ///
  ///If successful, it also signs the user in into the app and updates
  ///[FirebaseAuthController].
  ///
  /// **Important**: You must enable Email & Password accounts in the Auth
  /// section of the Firebase console before being able to use them.
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } on FirebaseAuthException catch (e) {
      Failure failure;
      switch (e.code) {
        case "invalid-email":
          failure = FirebaseInvalidEmailFailure(
            e,
            LocaleKeys.firebase_invalid_email.tr,
          );
          break;
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
        default:
          failure = FirebaseFailure(e, LocaleKeys.firebase_failure.tr);
      }

      return Left(failure);
    } catch (e) {
      return handleException(e);
    }
  }

  /// Tries to create a new user account with the given email address and password.
  Future<Either<Failure, UserCredential>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } on FirebaseAuthException catch (e) {
      Failure failure;
      switch (e.code) {
        case "invalid-email":
          failure = FirebaseInvalidEmailFailure(
            e,
            LocaleKeys.firebase_invalid_email.tr,
          );
          break;

        case "operation-not-allowed":
          failure = FirebaseOperationNotAllowedFailure(
            e,
            LocaleKeys.firebase_operation_not_allowed.tr,
          );
          break;

        case "email-already-in-use":
          failure = FirebaseEmailAlreadyInUserFailure(
            e,
            LocaleKeys.firebase_email_already_in_use.tr,
          );
          break;
        case "weak-password":
          failure = FirebaseWeekPasswordFailure(
            e,
            LocaleKeys.firebase_weak_password.tr,
          );
          break;
        default:
          failure = FirebaseFailure(e, LocaleKeys.firebase_failure.tr);
      }

      return Left(failure);
    } catch (e) {
      return handleException(e);
    }
  }
}
