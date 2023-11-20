// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_tick/app/my_app/about_us.dart';
import 'package:green_tick/app_theme.dart';
import 'package:green_tick/barcodeLoader.dart';
import 'package:green_tick/listofItems_Screen.dart';
import 'model/homelist.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';

String barcodeScanRes = '';
bool isMuted = false;
bool isVibrateOff = false;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

Map<dynamic, dynamic> mp = {};
// final textController = TextEditingController();

class SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  AnimationController? animationController;
  bool multiple = true;
  bool food = true;
  var value = false;
  final List<bool> _isSelected = [true, false];
  final textController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.nearlyWhite,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 15, left: 25, right: 25, bottom: 40),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUsScreen()));
                          },
                          icon: Icon(
                            Icons.info_outline_rounded,
                            size: 30,
                            color: AppTheme.dark_grey,
                          )),
                    ),
                    Center(
                        child:
                            Image.asset('assets/images/crop.png', height: 150)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleButtons(
                          isSelected: _isSelected,
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < _isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  _isSelected[buttonIndex] = true;
                                } else {
                                  _isSelected[buttonIndex] = false;
                                }
                              }
                              food = _isSelected[0];
                              // cosmetics = _isSelected[1];
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.blue[200],
                          selectedColor: Colors.blue[400],
                          fillColor: Colors.blue[10],
                          color: const Color.fromARGB(255, 63, 90, 39),
                          constraints: const BoxConstraints(
                            minHeight: 120.0,
                            minWidth: 159.0,
                          ),
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset("assets/images/food.png"),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "Food",
                                  style: TextStyle(
                                      fontFamily: "Roboto-Regular",
                                      fontSize: 20,
                                      color: AppTheme.darkText),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                      "assets/images/cosmetics.png"),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                const Text(
                                  "Cosmetics",
                                  style: TextStyle(
                                      fontFamily: "Roboto-Regular",
                                      fontSize: 20,
                                      color: AppTheme.darkText),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: AppTheme.grey,
                      thickness: 0.68,
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    TextField(
                      style: const TextStyle(
                          fontSize: 22,
                          color: AppTheme.darkText,
                          fontFamily: "Roboto-Regular.ttf"),
                      controller: textController,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.dark_grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.dark_grey),
                          ),
                          labelText: 'Product',
                          labelStyle: TextStyle(
                              color: AppTheme.dark_grey,
                              fontSize: 20,
                              fontFamily: "Roboto")),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        height: 100,
                        child: SizedBox(
                          height: 60,
                          width: 120,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue[50])),
                            onPressed: () async {
                              if (textController.text.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListProductsScreen(
                                        textController.text, food),
                                  ),
                                ).then((_) {
                                  textController.clear();
                                });
                              }
                              if (textController.text.isEmpty) {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    backgroundColor: AppTheme.chipBackground,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    title: const Text('Caution!'),
                                    content: const Text(
                                        "Product Name can't be Empty."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            color: AppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: "Roboto-Regular.ttf",
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.darkText),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 100,
                    // ),
                    SizedBox(
                      height: 70,
                    ),
                    // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

                    Container(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        child: SizedBox(
                          height: 60,
                          width: 250,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue[50])),
                            onPressed: () => scanBarcodeNormal(context, food),
                            icon: Icon(
                              Icons.qr_code_scanner_sharp,
                              color: AppTheme.darkText,
                              size: 22,
                            ),
                            label: Text(
                              "Search by Scan",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: AppTheme.darkText,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto-Regular.ttf'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: () => apiCall(),
                    //   icon: Icon(Icons.qr_code),
                    //   label: Text("Search api"),
                    // ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Widget appBar() {
  //   return SizedBox(
  //     height: AppBar().preferredSize.height + 30,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const <Widget>[
  //             Expanded(
  //               child: Padding(
  //                 padding: EdgeInsets.only(
  //                   top: 0,
  //                 ),
  //                 child: Text(
  //                   'Hello',
  //                   style: TextStyle(
  //                     fontSize: 30,
  //                     color: AppTheme.darkText,
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: "Roboto",
  //                     letterSpacing: 0.4,
  //                     height: 0.9,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const Divider(
  //           color: AppTheme.dark_grey,
  //           height: 2,
  //         )
  //       ],
  //     ),
  //   );
  // }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(
                        listData!.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        onTap: callBack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void refreshCode(String code) {
  barcodeScanRes = code;
  // notifyListeners();
}

AudioPlayer player = AudioPlayer();

Future scanBarcodeNormal(BuildContext context, bool food) async {
  // playSound();
  refreshCode('');
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
  // if (!mounted) return;

  if (barcodeScanRes == "-1") {
    return refreshCode('');
  } else if (barcodeScanRes.isNotEmpty) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BarCodeLoader(barcodeScanRes, food)));
    if (!isVibrateOff) {
      Vibration.vibrate(duration: 250);
    }
    if (!isMuted) {
      player.play(AssetSource('Barcode-scanner-beep-sound.mp3'), volume: .5);
    }
  }
}

void playSound() {
  player.play(AssetSource('Barcode-scanner-beep-sound.mp3'), volume: .5);
}
