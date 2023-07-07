import 'package:flutter/material.dart';
import 'package:minecords/modules/database.dart';
import 'package:minecords/screens/home/home.dart';
import 'package:minecords/screens/search/search.dart';

DatabaseManager dbManager = DatabaseManager();

Map<int, Widget> screens = const {
  0: HomeScreen(),
  1: SearchScreen(),
};