import 'package:flutter/widgets.dart';
import 'package:green_tick/app/app_home_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      // imagePath: 'assets/app/app.png',
      navigateScreen: const AppHomeScreen(prodName: '',),
    ),
  ];
}
