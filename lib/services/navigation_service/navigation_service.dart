import 'package:flutter/material.dart';
import 'package:note_arkadasim/pages/home/home_page.dart';

import '../../routes/routes.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();
  static NavigationService get instance => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? _oldRoute;

  /// Go to a named route with animation
  Future<dynamic>? go(String route, {Object? arguments}) {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      debugPrint('[NavigationService] NavigatorState is null!');
      return null;
    }
    _oldRoute = route;
    return currentState.push(_createRoute(route, arguments: arguments));
  }

  /// Replace current route with animation
  Future<dynamic>? replace(String route, {Object? arguments}) {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      debugPrint('[NavigationService] NavigatorState is null!');
      return null;
    }
    _oldRoute = route;
    return currentState.pushReplacement(_createRoute(route, arguments: arguments));
  }

  void back<T extends Object?>([T? result]) {
    final currentState = navigatorKey.currentState;
    if (currentState?.canPop() ?? false) {
      currentState?.pop(result);
    }
  }

  bool get canGoBack => navigatorKey.currentState?.canPop() ?? false;

  /// Private helper to create a route with fade+slide animation
  Route _createRoute(String routeName, {Object? arguments}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        // Burada routeName'e göre sayfa döndür
        return _getPageByRoute(routeName, arguments);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide + Fade animasyonu
        const beginOffset = Offset(0, 0.1);
        const endOffset = Offset.zero;
        const curve = Curves.ease;

        final offsetTween = Tween(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: curve));
        final fadeTween = Tween<double>(begin: 0, end: 1);

        return SlideTransition(
          position: animation.drive(offsetTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  Widget _getPageByRoute(String routeName, Object? arguments) {
    final builder = AppRoutes.routes[routeName];
    if (builder != null) {
      return builder(navigatorKey.currentContext!);
    }
    return const HomePage(); // Default sayfa
  }

}
