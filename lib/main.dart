import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'PushNotificationManager.dart';
import 'objects/vpd.dart';
import 'pages/dashboard.dart';
import 'providers/dataProvider.dart';
import 'providers/settingsProvider.dart';
import 'providers/storageProvider.dart';
import 'styles.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

class SufMobileApplication extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _SufMobileApplicationState createState() => _SufMobileApplicationState();
}

class _SufMobileApplicationState extends State<SufMobileApplication> {
  RiveAnimationController grow;
  RiveAnimationController wind;

  Artboard splashscreen;
  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/flares/splashscreen.riv').then(
      (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          final artboard = file.mainArtboard;
          grow = SimpleAnimation('Growing');
          wind = SimpleAnimation('Wind');
          artboard.addController(grow);
          artboard.addController(wind);
          //  artboard.addController(wind);
          setState(() => splashscreen = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //  AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return MaterialApp(
      title: "Smart Urban Farm",
      debugShowCheckedModeBanner: false,
      color: primaryColor,
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch: Colors.green,
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
              color: Colors.transparent,
              child: Center(
                child: splashscreen == null
                    ? const SizedBox()
                    : Rive(
                        artboard: splashscreen,
                      ),
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
  // Init VPD Class
  await VPD().loadJson(context);
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
