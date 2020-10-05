import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/main.dart';
import 'package:sgs/providers/storageProvider.dart';

import '../styles.dart';

List<Widget> getImageList(List<Image> imgs) {
  List<Widget> cardlist = [Padding(padding: EdgeInsets.only(top: 15))];
  imgs.forEach((element) {
    cardlist.add(ImageListItem(element));
  });
  return cardlist;
}

takePhoto() {
  print("take Photo");
}

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageProvider>(builder: (context, d, child) {
      List<Image> imgs = d.images;
      return AppBarHeader(
        isPage: true,
        theme: getTheme(),
        title: "Gallery",
        trailling: Container(),
        body: getImageList(imgs),
        actionButton: Container(
          height: 64,
          width: 64,
          child: FloatingActionButton(
            onPressed: () => takePhoto(),
            child: Icon(
              Icons.camera_alt,
              color: getTheme().primaryColor,
              size: 32,
            ),
          ),
        ),
      );
    });
  }
}

class ImageListItem extends StatelessWidget {
  final Image image;

  ImageListItem(this.image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width - 30,
      child: Card(
        elevation: cardElavation + 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: Colors.white,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: image,
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text(
                image.semanticLabel,
                style: sectionTitleStyle(context, Colors.black87),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              alignment: Alignment.topLeft,
              child: Text(
                "some text containing data from the time of the photo",
                style: TextStyle(color: Colors.black87),
              ),
            )
          ],
        ),
      ),
    );
  }
}
