import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FirebaseAnalyticsProvider {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseAnalytics get analytics => _analytics;

  FirebaseAnalyticsProvider._();

  static FirebaseAnalyticsProvider _i = FirebaseAnalyticsProvider._();
  static FirebaseAnalyticsProvider get instance => _i;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);
}
