import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageProvider extends ChangeNotifier {
  StorageReference listref = FirebaseStorage.instance.ref();
  var dbref = FirebaseDatabase.instance.reference();

  Map<String, StorageReference> imgRefs = new Map();
  List<Image> images = [];
  Map<String, String> urls = {};

  StorageProvider() {
    print("yeeeeee");
    var subscription = dbref.reference().child('images').onValue.listen(
      (event) {
        loadImages();
      },
    );
  }

  void takePicture() {
    dbref.child("photo").set(true);
  }

  Future<void> loadImages() async {
    imgRefs = await getImageReferences();

    await Future.wait(
      imgRefs.keys.map(
        (key) async => urls[key] = await imgRefs[key].getDownloadURL(),
      ),
    );

    urls.forEach((date, url) {
      if (images.every((element) => element.semanticLabel != date))
        images.add(Image.network(
          url = url,
          semanticLabel: date,
        ));
    });

    //need to call sort after all images are in the lis

    images.sort((img1, img2) {
      return img1.semanticLabel.compareTo(img2.semanticLabel);
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
}
