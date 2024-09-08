import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartconsultor/core/localization/app_localizations_delegate.dart';
import 'package:smartconsultor/features/dashboard/presentation/pages/dashboard.dart';
import 'package:smartconsultor/features/login/presentation/pages/login_page.dart';
import 'package:smartconsultor/features/splash/presentation/papes/spash_page.dart';
import 'core/di/injection_container.dart' as di;
import 'package:flex_color_scheme/flex_color_scheme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''),
        Locale('vn', ''),
      ],
      locale: const Locale('en'),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: FlexThemeData.light(scheme: FlexScheme.aquaBlue, useMaterial3: true),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.aquaBlue, useMaterial3: true),
      themeMode: ThemeMode.light,
      initialRoute: "/",
      onGenerateRoute: (settings) {
        Widget destinationRoute = getDestinationRoute(settings.name);
        return MaterialPageRoute(builder: (context) => destinationRoute, settings: settings);
      },
      routes: {
        '/': (BuildContext context) => SplashPage(),
        LoginPage.LOGIN_ROUTE: (BuildContext context) => LoginPage(),
        Dashboard.DASHBOARD_ROUTE: (BuildContext context) => Dashboard(),
      },
    );  
  }

  Widget getDestinationRoute(String? routeName) {
    Widget destinationRoute = SplashPage();

    switch (routeName) {
      case LoginPage.LOGIN_ROUTE:
        destinationRoute = LoginPage();
        break;
      case Dashboard.DASHBOARD_ROUTE:
        destinationRoute = Dashboard();
        break;
    }
    return destinationRoute;
  }      
}
