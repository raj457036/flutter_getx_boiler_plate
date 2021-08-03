import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../global/firebase/auth/firebase_auth_service.dart';
import '../core.dart';
import '../environment/env.dart';
import '../logger/logger.dart';

var _lastToken = "";

abstract class BaseRemoteProvider extends GetConnect {
  final FirebaseAuthService authService = Get.find<FirebaseAuthService>();

  int _maxRetries = 3;

  @override
  void onInit() {
    // base url for criptan api
    setBaseURL();
    httpClient.maxAuthRetries =
        Env.environment.config("MAX_RETRIES", defaultValue: 2);
    toggleSafeMode(false);

    super.onInit();
  }

  setBaseURL([String? base]) {
    httpClient.baseUrl = base ?? Env.environment.config("BACKEND_URL");
  }

  Future<Request> _authModifier(Request request) async {
    final token = await authService.firebaseUser?.getIdToken();

    if (_lastToken != token) {
      _lastToken = token ?? "";
      LogService.config(_lastToken);
    }

    if (token != null) {
      request.headers['authorization'] = "Bearer $token";
    }
    return request;
  }

  /// call this in `onInit` for all requests or any particular `request` to attach a bearer token
  /// to the requests.
  enableAuthenticator() {
    // adding bearer if user request is authenticatable
    httpClient.addRequestModifier(_authModifier);
  }

  /// call this in `onInit` for all requests or any particular `request` to detach a bearer token
  /// to the requests.
  disableAuthenticator() {
    // adding bearer if user request is authenticatable
    httpClient.removeRequestModifier(_authModifier);
  }

  Future<Response<T>> withRetryModifier<T>(
    Future<Response<T>> future, {
    int? retries,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    int _tryCount = 0;

    Response<T> response = Response<T>();

    while (_tryCount < (retries ?? _maxRetries)) {
      try {
        response = await future.timeout(timeout);
        _tryCount++;
        if (response.hasError) {
          await ((_tryCount + 1) * 200).milliseconds.delay();
        } else
          break;
      } catch (e) {
        await ((_tryCount + 1) * 200).milliseconds.delay();
        _tryCount++;
      }
    }

    _printDebugMessage(_tryCount, response.request?.url.toString());

    return response;
  }

  Future<Response<T>> withApiExceptionModifier<T>(
      Future<Response<T>> future) async {
    final Response<T> response = await future;
    //TODO change it according to usecase
    // if (response.hasError) {
    //   ApiError? apiError;
    //   try {
    //     apiError =
    //         ApiError.fromMap(response.body as Map<String, dynamic>);
    //   } catch (e) {}

    //   if (apiError != null) throw ApiException(apiError.message);
    // }
    return response;
  }

  _printDebugMessage(int tried, String? url) {
    final message = "Tried: $tried : $url";
    switch (tried) {
      case 1:
        LogService.info(message);
        break;
      case 2:
        LogService.warning(message);
        break;
      default:
        LogService.error(message);
    }
  }

  /// call this in `onInit` to set max auth requests before
  /// responding with an error/exceprintInfo
  setMaxRetries(int maxRetries) {
    _maxRetries = maxRetries;
  }

  /// call in `onInit` to toggle between actual exceptions
  /// and suppresed results.
  ///
  /// when safemode is enabled all the request will return a null
  /// body instead of throwing an exception.
  ///
  /// default: `false`
  toggleSafeMode(bool enable) {
    httpClient.errorSafety = enable;
  }
}
