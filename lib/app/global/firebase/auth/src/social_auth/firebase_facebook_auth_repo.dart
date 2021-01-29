import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

import '../../../../../core/core.dart';
import '../../firebase_auth_controller.dart';
import '../misc_extensions/extended_auth_repo.dart';

class FirebaseFacebookAuthRepository extends FirebaseAuthExtendedRepo {
  final FirebaseAuthController _controller = Get.find<FirebaseAuthController>();

  FirebaseAuth get auth => _controller.auth;

  /// Asynchronously signs in to Firebase with the given Facebook login Access Token credentials
  /// and returns additional identity provider data.
  ///
  /// If successful, it also signs the user in into the app and updates [FirebaseAuthController].
  ///
  /// If the user doesn't have an account already, one will be created automatically.
  ///
  /// **Important**: You must enable the relevant accounts in the Auth section
  /// of the Firebase console before being able to use them.
  Future<Either<Failure, UserCredential>> signIn() async {
    // Trigger the sign-in flow
    final AccessToken result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential credential =
        FacebookAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    try {
      final result = await auth.signInWithCredential(credential);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }
}
