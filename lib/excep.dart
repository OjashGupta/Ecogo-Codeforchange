import 'package:flutter/material.dart';
import 'package:green_tick/app_theme.dart';

class ExceptionScreen extends StatefulWidget {
  const ExceptionScreen({Key? key}) : super(key: key);

  @override
  ExceptionScreenState createState() => ExceptionScreenState();
}

class ExceptionScreenState extends State<ExceptionScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.white,
      body: Center(
        child: Column(
          children: [
           const SizedBox(height: 180,),
            Image.asset(
                "assets/app/cry.gif", width: MediaQuery.of(context).size.width - 100),
            const SizedBox(height: 20,),
            const Text('Oops! We ran into a problem.', style: AppTheme.headline),
          ],
        ),
      ),
    );
  }
}


