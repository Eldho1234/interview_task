import 'package:flutter/material.dart';
import 'package:interview_task/feature/auth/view/login_page.dart';
import 'package:interview_task/feature/auth/view/signup_page.dart';
import 'package:interview_task/feature/product/view/product_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String prodtDetails = '/prodDetails';
  static const String adminDashBoard = '/adminDash';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => ProductView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
