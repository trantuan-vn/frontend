// presentation/pages/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartconsultor/features/dashboard/presentation/pages/dashboard.dart';
import 'package:smartconsultor/features/login/presentation/pages/login_page.dart';
import 'package:smartconsultor/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:smartconsultor/core/di/di.dart' as di;

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SplashBloc>()..add(CheckAuthentication()),
      child: Scaffold(
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashAuthenticated) {
              Navigator.pushReplacementNamed(
                  context, Dashboard.DASHBOARD_ROUTE);
            } else if (state is SplashUnauthenticated) {
              Navigator.pushReplacementNamed(context, LoginPage.LOGIN_ROUTE);
            } else if (state is SplashError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushReplacementNamed(context, LoginPage.LOGIN_ROUTE);
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Thêm logo hoặc animation nếu muốn
                Image.asset('assets/logo.png', width: 100, height: 100),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
