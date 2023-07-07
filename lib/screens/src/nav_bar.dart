import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:minecords/provider/nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(
      builder: (context, value, child) => CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        index: value.currentIndex,
        onTap: (index) {
          value.setIndex(index);
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        items: [
          CurvedNavigationBarItem(
            child: Icon(
                value.currentIndex == 0 ? Icons.home : Icons.home_outlined),
          ),
          CurvedNavigationBarItem(
            child: Icon(
                value.currentIndex == 1 ? Icons.search : Icons.search_outlined),
          ),
        ],
      ),
    );
  }
}
