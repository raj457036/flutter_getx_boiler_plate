import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/get.dart';

import '../../../../../core/core.dart';
import '../../firebase_auth_controller.dart';
import '../misc_extensions/extended_auth_repo.dart';

class FirebaseTwitterAuthRepo extends FirebaseAuthExtendedRepo {
  final FirebaseAuthController _controller = Get.find<FirebaseAuthController>();

  FirebaseAuth get auth => _controller.auth;

  final key = 'twitter-consumer-key';
  final secret = 'twitter-consumer-secret';

  String consumerKey;
  String consumerSecret;

  bool get _isSetupComplete => consumerKey != null && consumerSecret != null;

  init() {
    consumerKey = Env.environment.config(key, silent: true);
    consumerSecret = Env.environment.config(secret, silent: true);

    if (consumerKey == null) {
      LogService.warning("Add $key to your environment to use GitHub Auth");
    }

    if (consumerSecret == null) {
      LogService.warning("Add $secret to your environment to use GitHub Auth");
    }
  }

  ///You will need to ensure that your application in the [Twitter Developer Portal](https://developer.twitter.com/)
  /// has a callback URL of *twittersdk://* for Android, and *twitterkit-CONSUMERKEY://* for iOS.
  ///
  ///
  /// Asynchronously signs in to Firebase with the given Twitter login Access Token credentials
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
          "Twitter Auth Failed! Environment not fetch $key and $secret.",
        ),
      );

    // Create a TwitterLogin instance
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();

    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;

    // Create a credential from the access token
    final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token, secret: twitterSession.secret);

    // Once signed in, return the UserCredential
    try {
      final result = await auth.signInWithCredential(credential);
      return Right(result);
    } catch (e) {
      return handleException(e);
    }
  }
}
