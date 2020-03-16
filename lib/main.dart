import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/pages/home.dart';
import 'package:sgs/pages/loadingscreen.dart';
import 'styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          display4: TextStyle(color: primaryColor, fontSize: 50.0),
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
           display4: TextStyle(color: accentColor, fontSize: 50.0),
        ),
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

  Widget getTab(context, index) {
    return [
      new Home(),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: SafeArea(
          child: Card(
            elevation: getCardElavation(context)+2,
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
                  activeColor: isDark(context) ? accentColor : primaryColor,
                  color: isDark(context) ? Colors.white12 : Colors.black12,
                  iconSize: 28,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 800),
                  tabBackgroundColor:
                      isDark(context) ? primaryColor : accentColor,
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
