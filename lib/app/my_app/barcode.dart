import 'package:flutter/material.dart';

import '../app_theme.dart';


class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  BarcodeScreenState createState() => BarcodeScreenState();
}

String aquaticScore = '';
String envScore = '';
String overallScore = '';
int len = 0;

class BarcodeScreenState extends State<BarcodeScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  var isLoaded = false;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    // Map ing = loading.mp;
    // aquaticScore = ing['Aquatic'];
    // envScore = ing['Environment'];
    // overallScore = ing['Overall'];
    // len = ing.length;
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    // addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  // void addAllListData() {
  //   int count = len + 1;
  //
  //   listViews.add(
  //     AnalysisView(
  //       animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
  //           parent: widget.animationController!,
  //           curve:
  //           Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
  //       animationController: widget.animationController!,
  //     ),
  //   );
  //   listViews.add(
  //     Text(
  //       'Higher the percentage => Higher the probability of risk',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontFamily:
  //         AppTheme.fontName,
  //         fontWeight: FontWeight.w500,
  //         fontSize: 15,
  //         letterSpacing: -0.1,
  //         color: AppTheme.grey
  //             .withOpacity(0.5),
  //       ),
  //     ),
  //   );
  //
  // }

  // Future<bool> getData() async {
  //   await Future<dynamic>.delayed(const Duration(milliseconds: 50));
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 400,
              child: Stack(
                children: <Widget>[
                  // getMainListViewUI(),
                  getAppBarUI(),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
            Image.asset("assets/app/analysis1.gif", height: 250)
          ],
        ),
      ),
    );
  }

  // Widget getMainListViewUI() {
  //   return FutureBuilder<bool>(
  //     future: getData(),
  //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //       return ListView.builder(
  //         controller: scrollController,
  //         padding: EdgeInsets.only(
  //           top: AppBar().preferredSize.height +
  //               MediaQuery.of(context).padding.top +
  //               24,
  //           bottom: 62 + MediaQuery.of(context).padding.bottom,
  //         ),
  //         itemCount: listViews.length,
  //         scrollDirection: Axis.vertical,
  //         itemBuilder: (BuildContext context, int index) {
  //           widget.animationController?.forward();
  //           return listViews[index];
  //         },
  //       );
  //     },
  //   );
  // }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Analysis',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            Image.asset("assets/app/financial-growth-analysis.png", height : 47),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
