import 'package:flutter/cupertino.dart';
import 'package:nmc_wrapper/utils/logger.dart';

class CustomRouteObserver extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    currentRoute = route.settings.name;
    logger('Current route: $currentRoute');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.name;
    logger('Current route after pop: $currentRoute');
  }
}
