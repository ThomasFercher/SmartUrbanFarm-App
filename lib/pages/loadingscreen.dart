import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sgs/styles.dart';

class LoadingScreen extends StatefulWidget {
  final Widget w;
  LoadingScreen({this.w});

  @override
  _LoadingScreenState createState() => new _LoadingScreenState(afterLoading: w);
}

class _LoadingScreenState extends State<LoadingScreen> {
  final Widget afterLoading;
  _LoadingScreenState({this.afterLoading});

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: afterLoading,
      image: new Image.asset('assets/logo_small.png'),
      backgroundColor: isDark(context) ? backgroundColor_d : backgroundColor,
      photoSize: 150.0,
      loaderColor: primaryColor,
    );
  }
}
