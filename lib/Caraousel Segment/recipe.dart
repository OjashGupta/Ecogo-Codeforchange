import 'package:flutter/material.dart';

class Recipe {
  Recipe(
      {this.recipeName = '',
      this.recipeImage = '',
      this.textShow = '',
      this.startColor,
      this.endColor});

  String recipeName;
  String recipeImage;
  Color? startColor;
  Color? endColor;
  String textShow;
}

var recipes = [
  Recipe(
    recipeName: 'Forever Chemicals',
    recipeImage: 'water.jpg',
    textShow: "There are more than 4.5K of fluorine-based compounds dubbed as the 'forever chemicals' found in everyday products.",
    startColor: const Color(0xFFe18b41),
    endColor: const Color(0xFFc7c73d),
  ),
  Recipe(
    recipeName: 'Corals',
    recipeImage: 'corals1.jpg',
    textShow:
        'Over 50% of coral larvae die in a span of 24 hours upon exposure to as low as 0.14 mg oxybenzone per litre of seawater.',
    startColor: const Color(0xFFe18b41),
    endColor: const Color(0xFFc7c73d),
  ),
  Recipe(
    recipeName: "Land Degradation",
    recipeImage: 'landdead.jpg',
    textShow:
        "If the current land pollution trend persists, the percentage is estimated to rise to 95% by 2050",
    startColor: const Color(0xFFe18b41),
    endColor: const Color(0xFFc7c73d),
  )
];
