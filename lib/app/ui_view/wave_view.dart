import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;
import '../app_theme.dart';

class WaveView extends StatefulWidget {
  final double percentageValue;

  const WaveView({Key? key, this.percentageValue = 100.0}) : super(key: key);

  @override
  WaveViewState createState() => WaveViewState();
}

List<Color> selectedColors = <Color>[
  Colors.blue[100]!,
  Colors.lightGreen[900]!,
  Colors.lightGreen[700]!,
  Colors.lightGreen[600]!,
  Colors.lightGreen,
  Colors.lightGreen[400]!,
  Colors.lightGreen[300]!,
  Colors.yellow[400]!,
  Colors.yellow,
  Colors.yellow[600]!,
  Colors.yellow[700]!,
  Colors.yellow[800]!,
  Colors.yellow[900]!,
  Colors.orange[800]!,
  Colors.amber[900]!,
  Colors.red[500]!,
  Colors.red[700]!,
  Colors.red[800]!,
  Colors.red[900]!,
];

int colorSelector(double num) {
  if (num <= 0) {
    return 0;
  } else if (num > 0 && num <= 5.5) {
    return 1;
  } else if (num > 5.5 && num <= 11) {
    return 2;
  } else if (num > 11 && num <= 16.5) {
    return 3;
  } else if (num > 16.5 && num <= 22) {
    return 4;
  } else if (num > 22 && num <= 27.5) {
    return 5;
  } else if (num > 27.5 && num <= 33) {
    return 6;
  } else if (num > 33 && num <= 38.5) {
    return 7;
  } else if (num > 38.5 && num <= 44) {
    return 8;
  } else if (num > 44 && num <= 49.5) {
    return 9;
  } else if (num > 49.5 && num <= 55) {
    return 10;
  } else if (num > 55 && num <= 60.5) {
    return 11;
  } else if (num > 60.5 && num <= 66) {
    return 12;
  } else if (num > 66 && num <= 71.5) {
    return 13;
  } else if (num > 71.5 && num <= 77) {
    return 14;
  } else if (num > 77 && num <= 82.5) {
    return 15;
  } else if (num > 82.5 && num <= 88) {
    return 16;
  } else if (num > 88 && num <= 93.5) {
    return 17;
  } else {
    return 18;
  }
}

class WaveViewState extends State<WaveView> with TickerProviderStateMixin {
  AnimationController? animationController;
  AnimationController? waveAnimationController;
  Offset bottleOffset1 = const Offset(0, 0);
  List<Offset> animList1 = [];
  Offset bottleOffset2 = const Offset(60, 0);
  List<Offset> animList2 = [];


  @override
  void initState() {
    double ss = widget.percentageValue;
    if (ss == -100) {
      ss = 50;
    } else if (ss <= 33) {
      ss = ss + 10;
    }
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    waveAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationController!
      .addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController?.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController?.forward();
        }
      });
    waveAnimationController!.addListener(() {
      animList1.clear();
      for (int i = -2 - bottleOffset1.dx.toInt(); i <= 60 + 2; i++) {
        animList1.add(
          Offset(
            i.toDouble() + bottleOffset1.dx.toInt(),
            math.sin((waveAnimationController!.value * 360 - i) %
                        360 *
                        vector.degrees2Radians) *
                    4 +
                (((100.0 - ss) * 160.0 / 100.0)),
          ),
        );
      }
      animList2.clear();
      for (int i = -2 - bottleOffset2.dx.toInt(); i <= 60 + 2; i++) {
        animList2.add(
          Offset(
            i.toDouble() + bottleOffset2.dx.toInt(),
            math.sin((waveAnimationController!.value * 360 - i) %
                        360 *
                        vector.degrees2Radians) *
                    4 +
                (((100.0 - ss) * 160.0 / 100.0)),
          ),
        );
      }
    });
    waveAnimationController?.repeat();
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    waveAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipper(animationController!.value, animList1),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedColors[colorSelector(widget.percentageValue)]
                      .withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      bottomLeft: Radius.circular(80.0),
                      bottomRight: Radius.circular(80.0),
                      topRight: Radius.circular(80.0)),
                  gradient: LinearGradient(
                    colors: [
                      selectedColors[colorSelector(widget.percentageValue)]
                          .withOpacity(0.2),
                      selectedColors[colorSelector(widget.percentageValue)]
                          .withOpacity(0.5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(animationController!.value, animList2),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedColors[colorSelector(widget.percentageValue)],
                  gradient: LinearGradient(
                    colors: [
                      selectedColors[colorSelector(widget.percentageValue)]
                          .withOpacity(0.4),
                      selectedColors[colorSelector(widget.percentageValue)]
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      bottomLeft: Radius.circular(80.0),
                      bottomRight: Radius.circular(80.0),
                      topRight: Radius.circular(80.0)),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 48),
            ),
            Positioned(
              top: 0,
              left: 6,
              bottom: 8,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 0,
              bottom: 16,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 24,
              bottom: 32,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: const Interval(0.6, 0.8, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 20,
              bottom: 0,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 16 * (1.0 - animationController!.value), 0.0),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(
                        animationController!.status == AnimationStatus.reverse
                            ? 0.0
                            : 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset("assets/app/bottle.png"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
