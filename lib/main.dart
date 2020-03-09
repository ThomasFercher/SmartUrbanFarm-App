import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/pages/loadingscreen.dart';
import 'styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Grow System',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: primaryColor,
        accentColor: accentColor,
        primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
        textTheme: Typography(platform: TargetPlatform.iOS).black,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        accentColor: accentColor_d,
        primaryColor: backgroundColor_d,
        canvasColor: backgroundColor_d,
        primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
        textTheme: Typography(platform: TargetPlatform.iOS).white,
      ),
      home: LoadingScreen(
        w: MyHomePage(title: 'Smart Grow System'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  List<Widget> tabs = [
    new Text("Home"),
    new Text("Gallery"),
    new Text("Options"),
  ];

  void setIndex(int i) {
    setState(() {
      index = i;
    });
  }

  bool isDark(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.light
        ? false
        : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // backgroundColor: backgroundColor,
      ),
      body: Center(
        child: tabs.elementAt(index),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: SafeArea(
          child: Card(
            elevation: 10,
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
                  activeColor: primaryColor,
                  color: isDark(context) ? Colors.white12 : Colors.black12,
                  iconSize: 28,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 800),
                  tabBackgroundColor: accentColor,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.photo,
                      text: 'Gallery',
                    ),
                    GButton(
                      icon: LineIcons.leaf,
                      text: 'Settings',
                    ),
                  ],
                  selectedIndex: index,
                  onTabChange: (index) => setIndex(index)),
            ),
          ),
        ),
      ),
    );
  }
}
