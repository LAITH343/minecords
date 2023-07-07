import 'package:flutter/material.dart';
import 'package:minecords/config.dart';
import 'package:minecords/provider/nav_bar.dart';
import 'package:minecords/screens/src/nav_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0 && value.currentIndex != 1) {
                value.setIndex(1);
              }
              if (details.primaryVelocity! > 0 && value.currentIndex != 0) {
                value.setIndex(0);
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                if (value.currentIndex == 1) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                } else if (value.currentIndex == 0) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                } else {
                  return child;
                }
              },
              child: screens[value.currentIndex]!,
            ),
          ),
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
