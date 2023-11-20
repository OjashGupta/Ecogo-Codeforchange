// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:green_tick/search_screen.dart';

import 'app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    var padding = MediaQuery.of(context).viewPadding;
    double height = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    double height1 = height - padding.top - padding.bottom;
    return Scaffold(
      backgroundColor:
          isLightMode == true ? AppTheme.white : AppTheme.nearlyBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            Image(
              height: height1,
              width: width1,
              image: const AssetImage('assets/app/NewScreen2.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 252, 183),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.navigate_next_outlined,
                    size: 25,
                    color: Color.fromARGB(255, 97, 130, 61),
                  )),
            )
          ]),
        ],
      ),
    );
  }
}
