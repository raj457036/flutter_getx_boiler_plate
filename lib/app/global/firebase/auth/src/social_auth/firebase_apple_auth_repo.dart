import 'package:boiler_plate/app/global/firebase/auth/firebase_auth_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../../../core/core.dart';
import '../../firebase_auth_controller.dart';
import '../misc_extensions/extended_auth_repo.dart';

class FirebaseAppleAuthRepo extends FirebaseAuthExtendedRepo {
  final FirebaseAuthController _controller = Get.find<FirebaseAuthController>();

  FirebaseAuth get auth => _controller.auth;

  Future<bool> get appleSignInAvailable => TheAppleSignIn.isAvailable();

  /// Asynchronously signs in to Firebase with the given Apple ID Token/Access Token pair credentials
  /// and returns additional identity provider data.
  ///
  /// If successful, it also signs the user in into the app and updates [FirebaseAuthController].
  ///
  /// If the user doesn't have an account already, one will be created automatically.
  ///
  /// **Important**: You must enable the relevant accounts in the Auth section
  /// of the Firebase console before being able to use them.
  Future<Either<Failure, UserCredential>> signIn() async {
    // Once signed in, return the UserCredential
    try {
      final AuthorizationResult appleResult =
          await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        LogService.error(appleResult.error.toString());
      }

      if ((appleResult.credential?.authorizationCode?.toList().isNotEmpty ??
              false) &&
          (appleResult.credential?.identityToken?.toList().isNotEmpty ??
              false)) {
        final AuthCredential credential = OAuthProvider('apple.com').credential(
          accessToken: String.fromCharCodes(
              appleResult.credential!.authorizationCode!.toList()),
          idToken: String.fromCharCodes(
              appleResult.credential!.identityToken!.toList()),
        );
        final result = await auth.signInWithCredential(credential);

        return Right(result);
      }
      return Left(FirebaseFailure("apple error", "apple error"));
    } catch (e) {
      return handleException(e);
    }
  }
}
