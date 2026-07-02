// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Helper method to reapply system UI after navigation

  static Future<T?> push<T>({
    required Widget screen,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) async {
    T? result;

    if (transitionBuilder != null) {
      result = await navigatorKey.currentState!.push<T>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionDuration: transitionDuration,
          transitionsBuilder: transitionBuilder,
        ),
      );
    } else {
      result = await navigatorKey.currentState!.push<T>(
        MaterialPageRoute(builder: (BuildContext context) => screen),
      );
    }

    return result;
  }

  /// Update your AppNavigator.pop() method to support returning a result:

  static void pop<T>({T? result}) {
    navigatorKey.currentState!.pop<T>(result);
  }

  // Push replacement with animation options
  static Future<void> pushReplacement({
    required Widget screen,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) async {
    if (transitionBuilder != null) {
      await navigatorKey.currentState!.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionDuration: transitionDuration,
          transitionsBuilder: transitionBuilder,
        ),
      );
    } else {
      await navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => screen),
      );
    }
  }

  // Pop a specific number of screens from the stack
  static void popSteps({required int steps}) {
    assert(steps > 0, 'Steps must be greater than 0');

    int count = 0;
    navigatorKey.currentState!.popUntil((route) {
      if (count >= steps) return true;
      count++;
      return false;
    });
  }

  // Push and remove all with animation options
  static dynamic pushAndRemoveAll({
    required Widget screen,
    RouteTransitionsBuilder? transitionBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) {
    dynamic result;
    if (transitionBuilder != null) {
      result = navigatorKey.currentState!.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionDuration: transitionDuration,
          transitionsBuilder: transitionBuilder,
        ),
        (Route route) => false,
      );
    } else {
      result = navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext c) => screen),
        (Route route) => false,
      );
    }

    return result;
  }

  static RouteTransitionsBuilder get cupertinoTransition => (
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    final slideInAnimation = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(animation);

    final slideOutAnimation = Tween(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).animate(secondaryAnimation);

    return SlideTransition(
      position: slideOutAnimation,
      child: SlideTransition(position: slideInAnimation, child: child),
    );
  };
}
