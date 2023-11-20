// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import './search_screen.dart';
import 'package:green_tick/app/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetoSearch();
  }

  _navigatetoSearch() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      body: Container(padding: EdgeInsets.only(left: 30),
        child: Center(
          child: Container(
            height: 500,
            width: 600,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/Logo-no-bg.png'),fit: BoxFit.cover),
              
            ),
        ),
          ),
      ));
  }
}
