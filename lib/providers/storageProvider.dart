import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageProvider extends ChangeNotifier {
  StorageReference listref = FirebaseStorage.instance.ref();
  var dbref = FirebaseDatabase.instance.reference();

  Map<String, StorageReference> imgRefs = new Map();
  List<Image> images = [];

  StorageProvider() {
    //loadImages();
  }

  Future<void> loadImages() async {
    images = [];
    imgRefs = await getImageReferences();
    imgRefs.forEach((date, element) async {
      var url = await element.getDownloadURL();
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
    notifyListeners();
  }

  Future<Map<String, StorageReference>> getImageReferences() async {
    return await dbref.child("images").limitToLast(10).once().then((data) {
      Map<String, String> map = Map.from(data.value);
      Map<String, StorageReference> imgs = new Map();
      map.forEach((key, value) {
        imgs[key] = FirebaseStorage.instance.ref().child('images/$value');
      });
      return imgs;
    });
  }
}
