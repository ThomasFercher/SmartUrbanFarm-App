import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/pages/advanced.dart';
import 'package:sgs/pages/home.dart';
import 'styles.dart';
import 'dart:async';
import 'dart:ui' as UI;
import 'package:flutter/services.dart';

void main() => {
      WidgetsFlutterBinding.ensureInitialized(),
      runApp(MyApp()),
    };

class MyApp extends StatelessWidget {
  final String assetName = 'assets/up_arrow.svg';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData,
      darkTheme: darkThemData,
      home: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              projectSnap.hasData == null ||
              projectSnap.connectionState == ConnectionState.waiting) {
            // Splashscreen using a Flare2d as a loading Animation
            return Container(
              color: isDark(context) ? Colors.black : Colors.white,
              child: FlareActor(
                'assets/plant.flr',
                alignment: Alignment.center,
                animation: "Growing",
              ),
            );
          } else {
            // Once loaded the main page will be displayed
            return MyHomePage(
              title: "Smart Grow System",
            );
          }
        },
        future: loadData(fb),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.temperature}) : super(key: key);

  final temperature;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // currently selected tab
  int index = 0;

  // This function returns the Tab of the given index
  Widget getTab(context, index) {
    return [
      new Home(
        temperature: temperature,
        humidity: humidity,
      ),
      new Advanced(
        temperatures: temperatures,
        humiditys: humiditys,
      ),
    ].elementAt(index);
  }

  // This function sets the new index value
  void setIndex(int i) {
    setState(() {
      index = i;
    });
  }

  // This function return the Backgroundpainter for the given tab
  CustomPainter getPainter(var i) {
    switch (i) {
      case 0:
        return HomePainter();
        break;
      case 1:
        return AdvancedPainter();
        break;
      default:
        return HomePainter();
    }
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
                  gap: 60,
                  icon: LineIcons.leaf,
                  text: 'Dashboard',
                ),
                GButton(
                  gap: 60,
                  icon: Icons.settings,
                  text: 'Advanced',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark(context) ? backgroundColor_d : primaryColor,
        elevation: 0,
        title: Container(color: Colors.green),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 45,
                  padding: EdgeInsets.only(top: 5, right: 5),
                  child: SvgPicture.asset(
                    "assets/leaf.svg",
                    color: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: CustomPaint(
        painter: isDark(context) ? null : getPainter(index),
        child: Container(
          margin: isDark(context) ? EdgeInsets.only(top: 25) : null,
          child: getTab(context, index),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}

/// This function loads the inital data from the database when the app starts.
Future<void> loadData(FirebaseDatabase fb) async {
  print("yee");
  final ref = fb.reference();
  await ref.child("temperature").once().then((DataSnapshot data) {
    temperature = data.value.runtimeType == double
        ? data.value
        : double.parse(data.value);
  });
  await ref.child("humidity").once().then((DataSnapshot data) {
    humidity = data.value.runtimeType == double
        ? data.value
        : double.parse(data.value);
  });
  await ref.child("suntime").once().then((DataSnapshot data) {
    suntime = data.value["suntime"];
  });
  await ref
      .child("temperatures")
      .limitToLast(10)
      .once()
      .then((DataSnapshot data) {
    temperatures = sortData(data.value);
  });
  await ref.child("humiditys").limitToLast(10).once().then((DataSnapshot data) {
    humiditys = sortData(data.value);
  });

  //add a delay so the animation plays through
  return Future.delayed(Duration(milliseconds: 2800));
}

Future<UI.Image> loadImageAsset(String assetName) async {
  final data = await rootBundle.load(assetName);
  return decodeImageFromList(data.buffer.asUint8List());
}

class HomePainter extends CustomPainter {
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;

    var height = 200.0;
    var path = Path();

    path.moveTo(0, height);
    path.quadraticBezierTo(
        size.width * 0.25, height - 30, size.width * 0.5, height);
    path.quadraticBezierTo(
        size.width * 0.75, height + 30, size.width * 1.0, height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AdvancedPainter extends CustomPainter {
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;
    var height = 20.0;
    var path = Path();

    path.moveTo(0, height);
    path.quadraticBezierTo(
        size.width * 0.25, height - 15, size.width * 0.5, height);
    path.quadraticBezierTo(
        size.width * 0.75, height + 15, size.width * 1.0, height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
