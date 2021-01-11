import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sgs/objects/photo.dart';
import 'package:sgs/objects/timeLapse.dart';
import 'package:sgs/styles.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class StorageProvider extends ChangeNotifier {
  //This class is used for the storage and processing of images and timelapses
  var firebase = FirebaseDatabase.instance.reference();

  Map<String, StorageReference> photoRefs = new Map();
  Map<String, String> photoUrls = {};
  List<Photo> photos = [];

  List<TimeLapse> timelapses = [];

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  bool computingTimelapse = false;

  final _flaresToWarmup = [
    AssetFlare(bundle: rootBundle, name: "assets/flares/moon.flr"),
    AssetFlare(bundle: rootBundle, name: "assets/flares/sun.flr"),
    AssetFlare(bundle: rootBundle, name: "assets/flares/grow.flr")
  ];

  StorageProvider() {
    // Reload Photos once photo is taken
    firebase.child("photo").onValue.listen((event) async {
      var value = event.snapshot.value;
      if (!value) {
        Directory directory = await getExternalStorageDirectory();
        downloadAndSafePhotos(directory);
        notifyListeners();
      }
    });
  }

  void takePhoto() {
    firebase.child("photo").set(true);
  }

  Future<void> loadFlares() async {
    //chaches the flares so they can be instantly used without loading
    for (final asset in _flaresToWarmup) {
      await cachedActor(asset);
    }
  }

  Future<void> downloadAndSafePhotos(Directory directory) async {
    //load other photos from the database which dont exist locally yet
    photoRefs = await getPhotoReferences();
    await Future.wait(
      photoRefs.keys.map(
        (key) async => photoUrls[key] = await photoRefs[key].getDownloadURL(),
      ),
    );

    http.Client client = new http.Client();
    String dPath = directory.path;

    // for each url download file if it doesnt exist locally
    photoUrls.forEach(
      (date, url) async {
        if (photos.every((element) => element.date != date))
          photos.add(
            await downloadPhotoAndSafe(client, url, date, dPath),
          );
      },
    );
  }

  Future<void> loadPhotos(context) async {
    //load photos from files
    Directory directory = await getExternalStorageDirectory();
    await Directory("${directory.path}/photos/").create();
    Directory photoDirectory = new Directory("${directory.path}/photos/");
    photos = loadPhotosFromFiles(photoDirectory);

    //load other photos from the database which dont exist locally yet
    await downloadAndSafePhotos(directory);

    //need to call sort after all images are in the lis
    photos.sort((photo1, photo2) {
      return photo1.date.compareTo(photo2.date);
    });

    photos.forEach((photo) {
      precacheImage(photo.image.image, context);
    });

    print("loaded phtos");

    notifyListeners();
  }

  List<Photo> loadPhotosFromFiles(Directory directory) {
    List<Photo> photos = [];
    directory.listSync().forEach((element) {
      File f = new File(element.path);
      // Get DatTime out of filename
      List<String> pathArguments = element.path.split("_");
      String date = pathArguments[1].replaceAll(".jpeg", "");
      // Add to local List
      photos.add(
        new Photo(
          file: f,
          date: date,
          image: new Image.file(f),
        ),
      );
    });

    return photos;
  }

  Future<Photo> downloadPhotoAndSafe(
      http.Client client, String url, String date, String directory) async {
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    var fileName = "photo_$date.jpeg";
    File file = new File("$directory/photos/$fileName");
    await file.writeAsBytes(bytes);

    return new Photo(file: file, date: date, image: Image.file(file));
  }

  Future<void> loadTimeLapses() async {
    // Get External Storage Directory
    Directory eDirectory = await getExternalStorageDirectory();
    // If Directory doesnt exist create it
    await Directory("${eDirectory.path}/timelapses/").create();
    // Get Directory Object for the Timelapses
    Directory timeLapseDirectory = new Directory("${eDirectory.path}/");
    // Go trough each File and create a TimeLapse from it
    timeLapseDirectory
      ..listSync().forEach((element) {
        if (element is File) {
          File file = new File(element.path);
          // Create name
          List<String> pathArguments = file.path.split("/");
          String name = pathArguments[pathArguments.length - 1];
          name = name.replaceAll(".mp4", "");
          List<String> nameArguments = name.split("-");
          // Create DateTimeRange from name
          DateTimeRange range = new DateTimeRange(
            start: DateTime.parse(nameArguments[0].replaceAll(".", "-")),
            end: DateTime.parse(nameArguments[1].replaceAll(".", "-")),
          );
          // Create TimeLapse Object
          TimeLapse timeLapse =
              new TimeLapse(file: file, range: range, name: name);
          // Only add the TimeLapse to List if it doesnt exist yet
          if (!timelapses.any((tl) => tl.file.path == file.path)) {
            timelapses.add(timeLapse);
          }
        }
      });

    print("loaded timelapses");
    notifyListeners();
  }

  Future<Map<String, StorageReference>> getPhotoReferences() async {
    return await firebase.child("images").once().then((data) {
      Map<String, StorageReference> imgs = new Map();
      if (data.value != null) {
        Map<String, String> map = Map.from(data.value);
        map.forEach((key, value) {
          imgs[key] = FirebaseStorage.instance.ref().child('images/$value');
        });
      }
      return imgs;
    });
  }

  //Saves the given image to the devices gallery
  void savePhoto(Photo photo) async {
    GallerySaver.saveImage(photo.file.path, albumName: "Smart Urban Farm").then(
      (bool success) {
        print("Saved to Gallery");
      },
    );
  }

  void deletePhoto(Photo photo) {
    photos.remove(photo);
    firebase.child("images").child(photo.date).remove();
    photoRefs[photo.date].delete();
    notifyListeners();
  }

  Future<void> createTimelapse(DateTimeRange range) async {
    //So we can display a loading animation
    computingTimelapse = true;
    notifyListeners();

    Completer c = new Completer();

    //Get all images in the given DateTimeRange
    List<Photo> ph = photos.where((element) {
      DateTime time = DateTime.parse(element.date);
      return time.isAfter(range.start) && time.isBefore(range.end);
    }).toList();

    // Cancels the function if the list is empty or null
    if (ph == null || ph.length == 0) {
      return;
    }

    // Get a temporary Directory to copy all the photos to
    Directory tDirectory = await getTemporaryDirectory();
    String tPath = tDirectory.path;

    // Copy Image to Cache
    for (var i = 0; i < ph.length; i++) {
      String n = i.toString().padLeft(3, '0');
      await ph[i].file.copy("$tPath/photo_$n.jpeg");
    }

    // Gets the external Directory to save the Timelapse permanently
    Directory eDirectory = await getExternalStorageDirectory();
    String ePath = eDirectory.path;

    // Create name of the timelapse
    String start = range.start.toString().split(" ")[0].replaceAll("-", ".");
    String end = range.end.toString().split(" ")[0].replaceAll("-", ".");
    String name = "$start-$end.mp4";

    _flutterFFmpeg
        .execute("-framerate 24 -i $tPath/photo_%03d.jpeg $ePath/$name")
        .then(
      (rc) async {
        print("FFmpeg process exited with rc $rc");
        print("Created TimeLapse");

        tDirectory.listSync().forEach((element) {
          element.deleteSync();
        });

        File timeLapseFile = new File("$ePath/$name");
        print("File created at: ${timeLapseFile.path}");

        name = name.replaceAll(".mp4", "");
        TimeLapse timeLapse =
            new TimeLapse(file: timeLapseFile, range: range, name: name);
        timelapses.add(timeLapse);
        computingTimelapse = false;
        c.complete();
        notifyListeners();
      },
    );

    return Future.wait([c.future]);
  }

  void deleteTimeLapse(TimeLapse tl) {
    tl.file.deleteSync();
    timelapses.remove(tl);
    notifyListeners();
  }

  void saveTimeLapse(TimeLapse tl) {
    GallerySaver.saveVideo(tl.file.path, albumName: "Smart Urban Farm").then(
      (bool success) {
        print("Saved to Gallery");
      },
    );
  }
}
