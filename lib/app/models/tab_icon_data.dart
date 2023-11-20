import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/app/earth1.png',
      selectedImagePath: 'assets/app/earth2.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/app/fish3.png',
      selectedImagePath: 'assets/app/fish4.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/app/tree6.png',
      selectedImagePath: 'assets/app/tree7.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/app/comp2.png',
      selectedImagePath: 'assets/app/comp3.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
