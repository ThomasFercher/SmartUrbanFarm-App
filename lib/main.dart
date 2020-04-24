import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/pages/home.dart';
import 'styles.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;
import 'package:flutter/services.dart';

void main() => {
      WidgetsFlutterBinding.ensureInitialized(),
      runApp(MyApp()),
    };

class MyApp extends StatelessWidget {
  final fb = FirebaseDatabase.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //  title: 'Smart Grow System',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: primaryColor,
        accentColor: accentColor,
        primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
        textTheme: TextTheme(
          //headline: TextStyle(color: accentColor),
          //title: TextStyle(color: accentColor),
          // subhead: TextStyle(color: accentColor),
          subtitle: TextStyle(color: Colors.white),
          display3: TextStyle(
              color: text_gray, fontSize: 13.0, fontWeight: FontWeight.w400),
          display4: TextStyle(color: primaryColor, fontSize: 30.0),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        accentColor: accentColor_d,
        primaryColor: backgroundColor_d,
        canvasColor: backgroundColor_d,
        textTheme: TextTheme(
          headline: TextStyle(color: accentColor),
          title: TextStyle(color: accentColor),
          subhead: TextStyle(color: accentColor),
          subtitle: TextStyle(color: Colors.white),
          display3: TextStyle(
              color: text_gray, fontSize: 13.0, fontWeight: FontWeight.w400),
          display4: TextStyle(color: accentColor, fontSize: 30.0),
          //headline1: TextStyle(color: accentColor),
        ),
      ),
      home: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              projectSnap.hasData == null ||
              projectSnap.connectionState == ConnectionState.waiting) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(
              child: FlareActor(
                'assets/sgs_logo.flr',
                alignment: Alignment.center,
                animation: "Logo",
              ),
            );
          }
          return MyHomePage(
            title: "Smart Grow System App",
          );
        },
        future: loadData(fb),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.temperature}) : super(key: key);
  final String title;
  final temperature;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  Widget getTab(context, index) {
    return [
      new Home(
        temperature: temperature,
      ),
      new Text(
        "Gallery",
        style: Theme.of(context).textTheme.subhead,
      ),
      new Text(
        "Options",
        style: Theme.of(context).textTheme.subhead,
      ),
    ].elementAt(index);
  }

  void setIndex(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? backgroundColor_d : backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark(context) ? backgroundColor_d : backgroundColor,
        elevation: 0,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Center(
        child: getTab(context, index),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: SafeArea(
        child: Card(
          elevation: getCardElavation(context) + 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: isDark(context) ? accentColor_d : backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: GNav(
              gap: 8,
              activeColor: accentColor,
              color: isDark(context) ? Colors.white12 : Colors.black12,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 800),
              tabBackgroundColor: primaryColor,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.photo,
                  text: 'Data',
                ),
                GButton(
                  icon: LineIcons.leaf,
                  text: 'Settings',
                ),
              ],
              selectedIndex: index,
              onTabChange: (index) => setIndex(index),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> loadData(FirebaseDatabase fb) async {
//  dusk_icon2 = await loadImageAsset("assets/icons/dusk_icon2.png");
  // dawn_icon = await loadImageAsset('assets/icons/dawn_icon.png');
//  dusk_icon = await loadImageAsset('assets/icons/dusk_icon.png');
//  midday_icon = await loadImageAsset('assets/icons/midday_icon.png');
  // night_icon = await loadImageAsset('assets/icons/night_icon.png');

  final ref = fb.reference();
  ref.child("temperature").once().then((DataSnapshot data) {
    temperature = data.value;
    print(data.value);
  });

  return Future.delayed(Duration(seconds: 0));
}

Future<UI.Image> loadUiImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final Completer<UI.Image> completer = Completer();
  UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

Future<UI.Image> loadImageAsset(String assetName) async {
  final data = await rootBundle.load(assetName);
  return decodeImageFromList(data.buffer.asUint8List());
}
