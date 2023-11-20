// ignore_for_file: prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:green_tick/api_service.dart';
import 'package:green_tick/app/app_theme.dart';
import 'package:green_tick/excep.dart';
import 'package:green_tick/loading.dart';

Map<dynamic, dynamic> mprod = {};
List<dynamic> prods = [];
String catName = 'Food';
String tsub = '';
String nameSearched = '';

class ListProductsScreen extends StatefulWidget {
  final String name1;
  final bool category;

  ListProductsScreen(this.name1, this.category);

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

// Map<dynamic, dynamic> mprod = {};
// List<dynamic> prods = [];
// String catName = 'Food';

class _ListProductsScreenState extends State<ListProductsScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  bool _isLoading = true;
  void getList() async {
    mprod = await ApiService().getIngredients(widget.name1, widget.category);
    setState(() {
      mprod = mprod;

      if (mprod.isEmpty || mprod.keys.first == "error") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => ExceptionScreen())));
      } else {
        prods = mprod.keys.toList();
        _isLoading = false;
      }
    });
  }

  @override
  void initState() {
    nameSearched = widget.name1;
    if (!widget.category) {
      catName = 'Cosmetics';
    }
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    getList();
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

  String convertIng(String name, bool category, Map<dynamic, dynamic> mprods) {
    List<String> dataList = mprods[name].cast<String>();
    if (category) {
      String joinedIngred = mprods[name][1].split(', ').join('; ');
      return joinedIngred;
    } else {
      String joinedIngred = dataList.join("; ");
      return joinedIngred;
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }
  // @override
  // void dispose() {
  //   mprod.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          child: Stack(
            children: [
              _isLoading ? buildLoader() : mainListUI(),
              appBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoader() {
    return Container(
        color: AppTheme.white,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: Image.asset(
                "assets/app/loading.png",
              ))),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  Widget appBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
            animation: animationController!,
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
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // textBaseline: TextBaseline.alphabetic,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8, left: 25, bottom: 0),
                                child: Text(
                                  "Searched:",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: AppTheme.fontName2,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                padding:const EdgeInsets.only(
                                      top: 5.0, left: 25, right: 0, bottom: 20), 
                            
                                  child: AutoSizeText(
                                    nameSearched,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    minFontSize: 16,
                                    maxFontSize: 26,
                                    stepGranularity: 2,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 25,
                                      letterSpacing: 1.2,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                              
                            ],
                          ),
                          widget.category
                              ? displayCategory("assets/app/cosmetics2.png")
                              : displayCategory("assets/app/cosmetics.png"),
                        ],
                      ),
                    ]),
                  ),
                ),
              );
            })
      ],
    );
  }

  Widget displayCategory(String imageLoc) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(bottom: 20, right: 25, top: 5),
      child: Image.asset(
        imageLoc,
        height: 47,
        fit: BoxFit.contain,
        alignment: Alignment.centerRight,
      ),
    ));
  }

  Widget mainListUI() {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snap) {
          if (!snap.hasData) {
            return SizedBox();
          } else {
            return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        50,
                    bottom: 62 + MediaQuery.of(context).padding.bottom),
                itemCount: prods.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  animationController?.forward();
                  String name = prods[index];
                  return Container(
                    height: 140,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Card(
                      borderOnForeground: true,
                      elevation: 0.9,
                      shadowColor: AppTheme.darkGrey,
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          var str = convertIng(name, widget.category, mprod);
                          if (widget.category) {
                            tsub = mprod[name][0];
                          } else {
                            tsub = "";
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                        prod_name: name,
                                        ingredients: str,
                                        subcategory: tsub,
                                        category: widget.category,
                                      ))).then((value) => () {});
                        },
                      ),
                    ),
                  );
                });
          }
        });
  }
}
