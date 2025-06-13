import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_routes.dart';
import 'package:interview_task/feature/auth/view/login_page.dart';
import 'package:interview_task/feature/auth/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ShoppingCart());
}

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
        home: LoginPage(),
      ),
    );
  }
}
