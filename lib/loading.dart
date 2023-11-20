// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, use_build_context_synchronously, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_tick/api_service.dart';
import 'package:green_tick/app/app_home_screen.dart';
import 'package:green_tick/app_theme.dart';
import 'package:green_tick/model/homeList.dart';
import 'excep.dart';
import 'package:green_tick/search_screen.dart' as search;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;


class LoadingScreen extends StatefulWidget {
  // final String text;
  final String prod_name;
  final String subcategory;
  final bool category;
  final String ingredients;

  const LoadingScreen({
    required this.prod_name,
    required this.ingredients,
    required this.subcategory,
    required this.category,
  });

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

Map<dynamic, dynamic> mp = {};
List simProducts = [];
List simProdScores = [];
final textController = TextEditingController();

void addToDatabase(Map ing, String text, String category, String sub_category) {
  for (var chemicals in ing.keys) {
    FirebaseFirestore.instance
        .collection('${category}_sub')
        .doc(sub_category).collection('scores').doc(text)
        .set({chemicals: ing[chemicals]}, SetOptions(merge: true));
  }

  for (var chemicals in ing.keys) {
    FirebaseFirestore.instance
        .collection(category)
        .doc(text.toLowerCase())
        .set({chemicals: ing[chemicals]}, SetOptions(merge: true));
  }
}

Future<bool> documentExistsInCollection(
    String collectionName, String docId) async {
  try {
    var doc = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .get();
    return doc.exists;
  } catch (e) {
    rethrow;
  }
}

class LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  AnimationController? animationController;

  var value = false;

  void navigatingFunc() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ExceptionScreen()),
    );
  }

  void function() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => homeList[0].navigateScreen!,
      ),
    );
  }

  Future<String?> fetchFirstSearchResult(String query) async {
    String res = search.barcodeScanRes;
    final response =
        await http.get(Uri.parse('https://www.google.com/search?q=$res'));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final linkElement = document.querySelector('.yuRUbf > a');
      return linkElement?.attributes['href'];
    } else {
      throw Exception('Failed to fetch search results');
    }
  }

  Future<void> fxn2(String category) async {
    String Category = '';
    if (widget.category == false){
      Category = 'cosmetics';
    }
    else{
      Category = 'food';
    }
    if (await documentExistsInCollection(
            category, widget.prod_name.toLowerCase()) ==
        false) {
      mp = (await ApiService()
          .getRating(widget.prod_name, widget.ingredients, widget.subcategory,
              Category)
          .whenComplete(() => value = true));
      setState(() {
        mp = mp;
        value = true;
      });
      if (mp['error'] == -1) {
        setState(() {
          value = false;
        });
        navigatingFunc();
      }
      if (mp.containsKey('error') == false) {
        addToDatabase(mp, widget.prod_name.toLowerCase(), category, mp['sub_category']);
      }
      await find_similar_products(mp);
      if (value == true) {
        function();
      }

    } else {
      final docRef = FirebaseFirestore.instance
          .collection(category)
          .doc(widget.prod_name.toLowerCase());
      docRef.get().then(
        (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            mp = data;
            value = true;
          });
          if (mp['error'] == -1) {
            setState(() {
              value = false;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExceptionScreen()),
            );
          }
          await find_similar_products(mp);

          if (value == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => AppHomeScreen(prodName: widget.prod_name),
              ),
            );
          }
        },
      );
    }
  }

  Future<void> find_similar_products(Map<dynamic, dynamic> mp) async {
    String category1 = '';
    if (widget.category == false){
      category1 = 'cosmetics_sub';
    }
    else{
      category1 = 'food_sub';
    }
    int count = 0;
    int docId = int.parse(mp['sub_category']); //has to be the subcategory
    setState(() {
      simProducts = [];
      simProdScores = [];
    });
    await FirebaseFirestore.instance
        .collection(category1) //collection' to be replaced by the category
        .doc(docId.toString())
        .collection('scores') //rename 00 to scores
        .orderBy('Overall')
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.id != widget.prod_name.toLowerCase()) {
            count++;
            simProducts.add(docSnapshot.id);
            simProdScores.add(docSnapshot.data()['Overall']);
            Map<String, dynamic> mp = docSnapshot.data();
            
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    if (docId == 10) {
      docId = -1;
    }
    while (count < 5) {
      docId++;
      if (docId == 10) {
        docId = 0;
      }
      await FirebaseFirestore.instance
          .collection(category1)
          .doc(docId.toString())
          .collection('scores')
          .orderBy('Overall')
          .get()
          .then(
        (querySnapshot1) {
          for (var docSnapshot in querySnapshot1.docs) {
            if (docSnapshot.id != widget.prod_name) {
              count++;
              
              simProducts.add(docSnapshot.id);
              simProdScores.add(docSnapshot.data()['Overall']);
              
              
              Map<String, dynamic> mp = docSnapshot.data();
              
            }
            if (count >= 5) {
              break;
            }
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    fxn3();
    super.initState();
  }

  Future<void> fxn3() async {
    if (widget.category == true) {
      await fxn2('food');
      setState(() {
        mp = mp;
      });
    } else {
      await fxn2('cosmetics');
      setState(() {
        mp = mp;
      });
    }
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
    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child:
                          Image.asset("assets/app/loading.png", height: 350)),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
    );
  }
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
