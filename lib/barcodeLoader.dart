// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_tick/api_service.dart';
import 'package:green_tick/app/app_theme.dart';
import 'package:green_tick/excep.dart';
import 'package:green_tick/loading.dart';
import 'package:http/http.dart' as http;

Map<dynamic, dynamic> itemMap = {};
String subcat = '';
Map<dynamic, dynamic> map = {};

class BarCodeLoader extends StatefulWidget {
  final String barCodeRes;
  final bool cat;
  BarCodeLoader(this.barCodeRes, this.cat);

  @override
  State<BarCodeLoader> createState() => _BarCodeLoaderState();
}

class _BarCodeLoaderState extends State<BarCodeLoader> {
  @override
  void initState() {
    barcodeIngd(widget.barCodeRes).then((itemMap) => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          if (itemMap.containsKey("Noresposne")) {
            return const ExceptionScreen();
          }
          if (itemMap.isNotEmpty) {
            return LoadingScreen(
                prod_name: itemMap.entries.first.key,
                ingredients:
                    convertIng(itemMap.entries.first.key, widget.cat, itemMap),
                subcategory: itemMap.entries.first.value[0],
                category: widget.cat);
          } else {
            return const ExceptionScreen();
          }
        })));

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

  Future<Map<dynamic, dynamic>> barcodeIngd(String barcode) async {
    var url = Uri.parse(
        'https://api.upcitemdb.com/prod/trial/lookup?upc=$barcode'); //come again here
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseMap["items"].isNotEmpty) {
        final name = responseMap["items"][0]["title"]; //we are getting the name
        itemMap = await ApiService().getIngredientsforBarcode(name, widget.cat);
        setState(() {
          itemMap = itemMap;
        });
        return itemMap;
      } else {
        return {'Noresposne': "HI"};
      }
    } else {
      throw Exception('http.get error: statusCode= ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Image.asset("assets/app/loading.png", height: 350)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
