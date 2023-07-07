import 'package:flutter/material.dart';
import 'package:minecords/app_theme.dart';
import 'package:minecords/provider/cords.dart';
import 'package:minecords/provider/nav_bar.dart';
import 'package:minecords/provider/search.dart';
import 'package:minecords/screens/splash/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Cords()),
      ChangeNotifierProvider(create: (_) => NavBarProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: const SplashScreen(),
    );
  }
}
