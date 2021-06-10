import 'dart:async';
import 'dart:io';

import '../../generated/locales.g.dart';
import 'exceptions/exceptions.dart';
import 'failures/failures.dart';

typedef Failure FailureCallback(BaseException exception);

// ignore: non_constant_identifier_names
final EXCEPTION_FAILURE_MAP = <Type, FailureCallback>{
  EnvironmentException: (e) => EnvironmentFailure(e.toString()),
  DatabaseException: (e) => BaseDatabaseFailure(actualException: e),
  NetworkException: (e) => BaseNetworkFailure(actualException: e),
  NoInternetConnectionException: (e) => NoInternetConnectionFailure(e),
  SocketException: (e) => NoInternetConnectionFailure(e),
  TimeoutException: (e) => RequestTimeoutFailure(e),
  BaseException: (e) => Failure(msg: LocaleKeys.failures_base, code: 0),
  GeneralException: (e) => BaseGeneralFailure(actualException: e),
};
