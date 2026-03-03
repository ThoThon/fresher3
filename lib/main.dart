import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/navigation/app_navigator.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final box = await Hive.openBox('settings');

  final String? token = box.get('token');
  final bool hasLogin = token != null && token.isNotEmpty;

  runApp(MyApp(initialRoute: hasLogin ? Routes.home : Routes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: AppPages.generateRoute,
    );
  }
}
