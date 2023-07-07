import 'package:flutter/material.dart';
import 'package:minecords/screens/splash/methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initDB(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "MineCords",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * .08,
          ),
        ),
      ),
    );
  }
}
