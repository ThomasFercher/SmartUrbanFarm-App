import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/pages/advanced.dart';
import 'package:sgs/pages/environment.dart';
import 'package:sgs/pages/gallery.dart';
import 'package:sgs/pages/home.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'providers/dashboardProvider.dart';
import 'styles.dart';
import 'dart:async';
import 'dart:ui' as UI;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/settings.dart';

void main() => {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: getTheme().background[1],
      )),
      WidgetsFlutterBinding.ensureInitialized(),
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DashboardProvider>(
              lazy: false,
              create: (_) => DashboardProvider(),
            ),
            ChangeNotifierProvider<StorageProvider>(
              lazy: true,
              create: (_) => StorageProvider(),
            ),
            ChangeNotifierProvider<SettingsProvider>(
              lazy: false,
              create: (_) => SettingsProvider(),
            ),
          ],
          child: MyApp(),
        ),
      )
    };

class MyApp extends StatelessWidget {
  final String assetName = 'assets/up_arrow.svg';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<DashboardProvider>(context, listen: false).loadData();
    return MaterialApp(
      theme: themeData,
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
        future: loadData(context),
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
  static const String EnvironmentSettings = 'Environment';
  static const String Settings = 'Settings';
  static const String SignOut = 'About';

  static const List<String> choices = <String>[
    EnvironmentSettings,
    Settings,
    SignOut
  ];

  // This function return the Backgroundpainter for the given tab
  CustomPainter getPainter() {
    switch (getTheme().name) {
      case "light":
        return LightPainter();
        break;
      case "dark":
        return DarkPainter();
        break;
      default:
        return CoolPainter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: getTheme().background[1],
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: getTheme().background[0],
              elevation: 0,
              actions: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 35,
                        padding: EdgeInsets.only(bottom: 5, right: 5),
                        child: SvgPicture.asset(
                          "assets/leaf.svg",
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        padding: EdgeInsets.only(top: 5, left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 42,
                        alignment: Alignment.center,
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            size: 30,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          color: Colors.white,
                          elevation: getCardElavation(context),
                          onSelected: choiceAction,
                          itemBuilder: (BuildContext context) {
                            return choices.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: getTheme().name == "cool"
                    ? LinearGradient(
                        colors: getTheme().background,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)
                    : null,
              ),
              child: CustomPaint(
                painter: getPainter(),
                child: Home(),
              ),
              //  bottomNavigationBar: bottomNavigationBar(),
            ),
          ),
        );
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == Settings) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: Provider.of<SettingsProvider>(context),
            child: SettingsPage(),
          ),
        ),
      );
    } else if (choice == EnvironmentSettings) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: Provider.of<DashboardProvider>(context),
            child: Environment(),
          ),
        ),
      );
    } else if (choice == SignOut) {
      print('SignOut');
    }
  }
}

/// This function loads the inital data from the database when the app starts.
Future<void> loadData(context) async {
  Stopwatch stopwatch = new Stopwatch()..start();
  await Provider.of<DashboardProvider>(context, listen: false).loadData();
  await Provider.of<StorageProvider>(context, listen: false).loadImages();
  stopwatch.stop();

  //add a delay so the animation plays through
  return Future.delayed(
    Duration(milliseconds: 3000 - stopwatch.elapsedMilliseconds),
  );
}

Future<UI.Image> loadImageAsset(String assetName) async {
  final data = await rootBundle.load(assetName);
  return decodeImageFromList(data.buffer.asUint8List());
}

class LightPainter extends CustomPainter {
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var height = 180.0;
    var path = new Path();

    path = new Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);
    path.close();

    path = new Path();
    paint.color = getTheme().background[0];
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

class DarkPainter extends CustomPainter {
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;

    var height = 180.0;
    var path = new Path();

    path = new Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);
    path.close();

    paint.color = Colors.blueAccent;
    path = new Path();
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

class CoolPainter extends CustomPainter {
  //drawing
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
