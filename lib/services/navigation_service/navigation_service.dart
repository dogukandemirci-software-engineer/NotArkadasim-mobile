import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();
  static NavigationService get instance => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? _oldRoute;

  Future<dynamic>? go(String route, {Object? arguments}) {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      debugPrint('[NavigationService] NavigatorState is null!');
      return null;
    }
    _oldRoute = route;
    return currentState.pushNamed(route, arguments: arguments);
  }

  Future<dynamic>? replace(String route, {Object? arguments}) {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      debugPrint('[NavigationService] NavigatorState is null!');
      return null;
    }
    _oldRoute = route;
    return currentState.pushReplacementNamed(route, arguments: arguments);
  }

  void back<T extends Object?>([T? result]) {
    final currentState = navigatorKey.currentState;
    if (currentState?.canPop() ?? false) {
      currentState?.pop(result);
    }
  }

  bool get canGoBack => navigatorKey.currentState?.canPop() ?? false;
}
