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
import 'package:sgs/objects/timeLapse.dart';
import 'package:sgs/styles.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class StorageProvider extends ChangeNotifier {
  var dbref = FirebaseDatabase.instance.reference();

  Map<String, StorageReference> imgRefs = new Map();
  Map<String, String> urls = {};
  List<Image> images = [];

  List<TimeLapse> timelapses = [];

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  final _assetsToWarmup = [
    AssetFlare(bundle: rootBundle, name: "assets/flares/moon.flr"),
    AssetFlare(bundle: rootBundle, name: "assets/flares/sun.flr"),
    AssetFlare(bundle: rootBundle, name: "assets/flares/grow.flr")
  ];

  StorageProvider() {
    /*var subscription = dbref.reference().child('images').onValue.listen(
      (event) {
        loadImages();
      },
    );*/
  }

  void takePicture() {
    dbref.child("photo").set(true);
  }

  Future<void> loadFlares() async {
    //chaches the flares so they can be instantly used without loading
    for (final asset in _assetsToWarmup) {
      await cachedActor(asset);
    }
  }

  Future<void> loadImages(context) async {
    imgRefs = await getImageReferences();

    await Future.wait(
      imgRefs.keys.map(
        (key) async => urls[key] = await imgRefs[key].getDownloadURL(),
      ),
    );

    urls.forEach((date, url) {
      if (images.every((element) => element.semanticLabel != date))
        images.add(
          new Image.network(
            url,
            semanticLabel: date,
            height: 360,
          ),
        );
    });

    //need to call sort after all images are in the lis

    images.sort((img1, img2) {
      return img1.semanticLabel.compareTo(img2.semanticLabel);
    });

    images.forEach((element) {
      precacheImage(element.image, context);
    });

    print("loaded images");

    notifyListeners();
  }

  Future<void> loadTimeLapses() async {
    Directory eDirectory = await getExternalStorageDirectory();
    eDirectory.listSync().forEach((element) {
      File f = new File(element.path);
      List<String> pathArguments = element.path.split("/");
      String name = pathArguments[pathArguments.length - 1];
      name = name.replaceAll(".mp4", "");
      List<String> nameArguments = name.split("-");
      DateTimeRange range = new DateTimeRange(
        start: DateTime.parse(nameArguments[0].replaceAll(".", "-")),
        end: DateTime.parse(nameArguments[1].replaceAll(".", "-")),
      );

      TimeLapse timeLapse =
          new TimeLapse(file: f, range: range, daterange: name);
      if (!timelapses.any((tl) => tl.file.path == f.path)) {
        timelapses.add(timeLapse);
      }
    });

    print("loaded timelapses");

    notifyListeners();
  }

  Future<Map<String, StorageReference>> getImageReferences() async {
    return await dbref.child("images").limitToLast(10).once().then((data) {
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
  void saveImage(Image image) async {
    String url = await imgRefs[image.semanticLabel].getDownloadURL();

    http.Client _client = new http.Client();
    var req = await _client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String directory = (await getTemporaryDirectory()).path;
    String fileName = basename(Uri.decodeFull(url));
    fileName = fileName.split("?")[0]; //remove access key from basename

    File tempFile = new File('$directory/$fileName');
    await tempFile.writeAsBytes(bytes);
    print("Created temporary File at ${tempFile.path}");

    GallerySaver.saveImage(tempFile, albumName: "Smart Urban Farm").then(
      (bool success) {
        print("Saved to Gallery");
        tempFile.deleteSync();
      },
    );
  }

  void deleteImage(Image image) {
    images.remove(image);
    dbref.child("images").child(image.semanticLabel).remove();
    imgRefs[image.semanticLabel].delete();
    notifyListeners();
  }

  Future<void> createImageFile(
      Image image, http.Client client, String directory, int i) async {
    String url = await imgRefs[image.semanticLabel].getDownloadURL();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;

    String n = i.toString().padLeft(3, '0');
    String fileName = "photo_$n.jpeg";
    File tempFile = new File('$directory/$fileName');
    await tempFile.writeAsBytes(bytes);

    print("Created temporary File at ${tempFile.path}");
  }

  Future<void> createTimelapse(DateTimeRange range) async {
    //Get all images in the given DateTimeRange
    List<Image> imgs = images.where((element) {
      DateTime time = DateTime.parse(element.semanticLabel);
      return time.isAfter(range.start) && time.isBefore(range.end);
    }).toList();

    // Cancels the function if the list is empty
    if (imgs == null || imgs.length == 0) {
      return;
    }

    // Get a temporary Directory to save all the images in
    Directory tDirectory = await getTemporaryDirectory();
    String tPath = tDirectory.path;

    // Create a http Client to download all needed images as we dont store all
    // the images from the gallery locally
    http.Client _client = new http.Client();
    for (var i = 0; i < imgs.length; i++) {
      await createImageFile(imgs[i], _client, tPath, i);
    }
    _client.close();

    // Gets the external Directory to save the Timelapse permanently
    Directory eDirectory = await getExternalStorageDirectory();
    String ePath = eDirectory.path;
    String name =
        "${range.start.toString().split(" ")[0].replaceAll("-", ".")}-${range.end.toString().split(" ")[0].replaceAll("-", ".")}.mp4";

    _flutterFFmpeg
        .execute("-framerate 24 -i $tPath/photo_%03d.jpeg $ePath/$name")
        .then(
      (rc) async {
        print("FFmpeg process exited with rc $rc");
        print("Created TimeLapse");

        tDirectory.listSync().forEach((element) {
          element.deleteSync();
        });

        File tFile = new File("$ePath/$name");
        name = name.replaceAll(".mp4", "");
        TimeLapse timeLapse =
            new TimeLapse(file: tFile, range: range, daterange: name);
        timelapses.add(timeLapse);

        notifyListeners();
      },
    );
  }

  void deleteTimeLapse(TimeLapse tl) {
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
