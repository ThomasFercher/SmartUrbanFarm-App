import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/main.dart';
import 'package:sgs/providers/storageProvider.dart';

import '../styles.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Consumer<StorageProvider>(builder: (context, d, child) {
        List<Image> imgs = d.images;
        return ListView.builder(
          itemCount: imgs.length,
          itemBuilder: (context, index) {
            return ImageListItem(imgs[index]);
          },
        );
      }),
    );
  }
}

class ImageListItem extends StatelessWidget {
  final Image image;

  ImageListItem(this.image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.all(15),
      child: Card(
        elevation: cardElavation + 2,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text(
                image.semanticLabel,
                style: sectionTitleStyle(context, Colors.black87),
              ),
            ),
            image,
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child:
                  Text("some text containing data from the time of the photo"),
            )
          ],
        ),
      ),
    );
  }
}
