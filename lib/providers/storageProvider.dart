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
import 'package:sgs/styles.dart';
import 'package:gallery_saver/gallery_saver.dart';

class StorageProvider extends ChangeNotifier {
  var dbref = FirebaseDatabase.instance.reference();

  Map<String, StorageReference> imgRefs = new Map();
  List<Image> images = [];
  Map<String, String> urls = {};

  final _assetsToWarmup = [
    AssetFlare(bundle: rootBundle, name: "assets/flares/moon.flr"),
    AssetFlare(bundle: rootBundle, name: "assets/flares/sun.flr"),
    AssetFlare(bundle: rootBundle, name: "assets/flares/grow.flr")
  ];

  StorageProvider() {
    print("yeeeeee");
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
    String directory = (await getExternalStorageDirectory()).path;
    String fileName = basename(Uri.decodeFull(url));
    fileName = fileName.split("?")[0]; //remove access key from basename

    File tempFile = new File('$directory/$fileName');
    await tempFile.writeAsBytes(bytes);
    print('File size:${await tempFile.length()}');
    print(tempFile.path);

    GallerySaver.saveImage(tempFile, albumName: "Smart Urban Farm").then(
      (bool success) {
        print("Saved to Gallery");
      },
    );
  }

  void deleteImage(Image image) {
    images.remove(image);
    notifyListeners();
  }
}
