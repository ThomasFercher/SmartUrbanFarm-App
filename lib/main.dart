import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:sgs/PushNotificationManager.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/pages/dashboard.dart';
import 'package:sgs/providers/notificationProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'providers/dataProvider.dart';
import 'styles.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'styles.dart';
import 'styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: primaryColor,
    ),
  );
  firebaseDatabase.setPersistenceEnabled(true);
  firebaseDatabase.setPersistenceCacheSizeBytes(10000000);
  FlareCache.doesPrune = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
          lazy: false,
          create: (_) => DataProvider(),
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
      child: SufMobileApplication(),
    ),
  );
}

class SufMobileApplication extends StatelessWidget {
  // This widget is the root of your application.

  FlareControls flrctrl = new FlareControls();

  @override
  Widget build(BuildContext context) {
    //  AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: primaryColor,
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch:Colors.green,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled,
              fillColor: Colors.transparent,
            ),
            TargetPlatform.iOS: FadeThroughPageTransitionsBuilder()
          },
        ),
      ),
      home: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              projectSnap.hasData == null ||
              projectSnap.connectionState == ConnectionState.waiting) {
            // Splashscreen using a Flare2d as a loading Animation
            return Container(
              color: primaryColor,
              child: FlareActor(
                'assets/flares/splashscreen.flr',
                alignment: Alignment.center,
                animation: "Loading",
                controller: flrctrl,
                callback: (s) {
                  flrctrl.play("Wind");
                },
              ),
            );
          } else {
            // Once loaded the main page will be displayed
            return Dashboard();
          }
        },
        future: loadInitialData(context),
      ),
    );
  }
}

/// This function loads the inital data from the database when the app starts.
Future<void> loadInitialData(context) async {
  // Init PushNotificationsManager for notfications
  await PushNotificationsManager().init();
  // Log into Firebase to be able to access data
  await FirebaseAuth.instance.signInAnonymously();

  Stopwatch stopwatch = new Stopwatch()..start();
  await Provider.of<DataProvider>(context, listen: false).loadData();
  await Provider.of<StorageProvider>(context, listen: false)
      .loadPhotos(context);
  await Provider.of<StorageProvider>(context, listen: false).loadFlares();
  await Provider.of<StorageProvider>(context, listen: false).loadTimeLapses();
  await Provider.of<SettingsProvider>(context, listen: false).loadSettings();

  stopwatch.stop();
  print("Time needed ${stopwatch.elapsedMilliseconds}");
  //add a delay so the animation plays through
  return Future.delayed(
    Duration(milliseconds: 3000 - stopwatch.elapsedMilliseconds),
  );
}
