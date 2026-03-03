import 'package:flutter/material.dart';

import '../category/category_form/ui/category_form_screen.dart';
import '../category/entities/category.dart';
import '../home/ui/home_screen.dart';
import '../login/ui/login_screen.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.categoryForm:
        final category = settings.arguments as Category?;
        return MaterialPageRoute(
          builder: (_) => CategoryFormScreen(initialCategory: category),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
