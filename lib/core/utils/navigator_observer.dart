import 'package:flutter/material.dart';
import 'package:smartconsultor/core/log/log_manager.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  void _logWithTrace(
      String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final fullStackTrace = StackTrace.current
        .toString()
        .split('\n')
        .map((line) => '│ 💡   $line')
        .join('\n');

    final routeName = route?.settings.name ?? route.runtimeType.toString();
    final previousName =
        previousRoute?.settings.name ?? previousRoute?.runtimeType.toString();

    LogManager.logInfo('''
💡 $action
│ 💡   Route: $routeName
│ 💡   From: $previousName
│ 💡   Navigator stack top: ${navigator?.widget.initialRoute ?? '/'}
│ 💡   Full call stack:
$fullStackTrace
''');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logWithTrace("Pushed route", route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logWithTrace("Popped route", route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logWithTrace("Removed route", route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logWithTrace("Replaced route", newRoute, oldRoute);
  }
}
