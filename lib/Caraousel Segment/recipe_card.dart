import 'dart:ui';

import 'package:flutter/material.dart';

import 'recipe.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, this.active, this.index, this.recipe})
      : super(key: key);

  final bool? active;
  final int? index;
  final Recipe? recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool _isTextVisible = false;

  double fxn() {
    if (_isTextVisible) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final double blur = widget.active! ? 16 : 0;
    final double offset = widget.active! ? 4 : 0;
    final double top = widget.active! ? 0 : 46;

    return GestureDetector(
        onTapDown: (details) {
          setState(() {
            _isTextVisible = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            _isTextVisible = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          margin: EdgeInsets.only(
            top: top,
            bottom: 0,
            right: 15.5,
            left: widget.active! ? 32.5 : 0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: widget.recipe!.startColor!,
            boxShadow: [
              BoxShadow(
                color: Colors.black87.withOpacity(0.1),
                blurRadius: blur,
                offset: Offset(0, offset),
              )
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: widget.recipe!.startColor!,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(0),
                      blurRadius: blur,
                      offset: Offset(0, offset),
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/${widget.recipe!.recipeImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: fxn(), sigmaY: fxn()),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
              Container(
                child: _isTextVisible
                    ? Positioned.fill(
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          child: Center(
                            child: Text(
                              widget.recipe!.textShow,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          // color: widget.recipe!.startColor!,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87.withOpacity(0),
                              blurRadius: blur,
                              offset: Offset(0, offset),
                            )
                          ],
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 16,
                    top: 10,
                  ),
                  height: 50,
                  child: Text(
                    widget.recipe!.recipeName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
