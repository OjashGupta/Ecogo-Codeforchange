import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//declare encrypted prefs
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

//keys
GlobalKey<ScaffoldState> mainKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> appKey = GlobalKey<ScaffoldState>();
