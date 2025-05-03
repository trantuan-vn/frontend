import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartconsultor/core/localization/app_localizations_delegate.dart';
//import 'package:smartconsultor/core/utils/navigator_observer.dart';
import 'package:smartconsultor/features/dashboard/presentation/pages/dashboard.dart';
import 'package:smartconsultor/features/login/presentation/pages/login_page.dart';
import 'package:smartconsultor/features/splash/presentation/papes/spash_page.dart';
import 'core/di/di.dart' as di;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  //setUrlStrategy(PathUrlStrategy());
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  di.configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  //final CustomNavigatorObserver navigatorObserver = CustomNavigatorObserver();

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''),
        Locale('vn', ''),
      ],
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme:
          FlexThemeData.light(scheme: FlexScheme.aquaBlue, useMaterial3: true),
      darkTheme:
          FlexThemeData.dark(scheme: FlexScheme.aquaBlue, useMaterial3: true),
      themeMode: ThemeMode.light,
      initialRoute: "/",
      //navigatorObservers: [navigatorObserver],
      onGenerateRoute: (settings) {
        Widget destinationRoute = getDestinationRoute(settings.name);
        return MaterialPageRoute(
            builder: (context) => destinationRoute, settings: settings);
      },
      routes: {
        '/': (BuildContext context) => const SplashPage(),
        LoginPage.LOGIN_ROUTE: (BuildContext context) => const LoginPage(),
        Dashboard.DASHBOARD_ROUTE: (BuildContext context) => const Dashboard(),
      },
    );
  }

  Widget getDestinationRoute(String? routeName) {
    Widget destinationRoute = const SplashPage();
    final uri = Uri.parse(routeName ?? '/');
    final path = uri.path;
    switch (path) {
      case LoginPage.LOGIN_ROUTE:
        destinationRoute = const LoginPage();
        break;
      case Dashboard.DASHBOARD_ROUTE:
        destinationRoute = const Dashboard();
        break;
    }
    return destinationRoute;
  }
}
