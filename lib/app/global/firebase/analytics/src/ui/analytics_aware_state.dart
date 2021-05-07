import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';

import '../../analytics.dart';

abstract class AnalyticRouteAwareState<T extends StatefulWidget>
    extends State<T> with RouteAware {
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsProvider.instance.observer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = ModalRoute.of(context);
    if (state != null) observer.subscribe(this, state as PageRoute);
  }

  @override
  void dispose() {
    observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    observer.analytics.setCurrentScreen(
      screenName: getActivePage(),
    );
  }

  String getActivePage();
}
