// ignore_for_file: depend_on_referenced_packages

import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import '../utils/keys.dart';
import '../barcode_provider.dart';

List<SingleChildWidget> providersAll = [
  ChangeNotifierProvider<BarcodeProvider>(
      create: (context) => BarcodeProvider()),
];

var provdBarcode =
    Provider.of<BarcodeProvider>(appKey.currentContext!, listen: false);
