import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:github_sign_in/github_sign_in.dart';

import '../../../../../core/core.dart';
import '../../firebase_auth_controller.dart';
import '../misc_extensions/extended_auth_repo.dart';

class FirebaseGitHubAuthRepository extends FirebaseAuthExtendedRepo {
  final FirebaseAuthController _controller = Get.find<FirebaseAuthController>();

  FirebaseAuth get auth => _controller.auth;

  final key = 'github-client-id';
  final secret = 'github-client-secret';

  late String? clientId, clientSecret;

  bool get _isSetupComplete => clientId != null && clientSecret != null;

  init() {
    clientId = Env.environment.config(key, silent: true);
    clientSecret = Env.environment.config(secret, silent: true);

    if (clientId == null) {
      LogService.warning("Add $key to your environment to use GitHub Auth");
    }

    if (clientSecret == null) {
      LogService.warning("Add $secret to your environment to use GitHub Auth");
    }
  }

  /// Asynchronously signs in to Firebase with the given Github login Access Token credentials
  /// and returns additional identity provider data.
  ///
  /// If successful, it also signs the user in into the app and updates [FirebaseAuthController].
  ///
  /// If the user doesn't have an account already, one will be created automatically.
  ///
  /// **Important**: You must enable the relevant accounts in the Auth section
  /// of the Firebase console before being able to use them.
  Future<Either<Failure, UserCredential>> signIn() async {
    if (!_isSetupComplete)
      return Left(
        EnvironmentFailure(
          "Github Auth Failed! Environment not fetch $key and $secret.",
        ),
      );

    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUrl: 'https://my-project.firebaseapp.com/__/auth/handler');

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(Get.context);

    // Create a credential from the access token
    final AuthCredential credential =
        GithubAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    try {
      final result = await auth.signInWithCredential(credential);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }
}
