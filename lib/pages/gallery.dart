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

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: getTheme().headlineColor,
      ),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AppBarHeader(
                isPage: true,
                theme: getTheme(),
                title: "Gallery",
                trailling: Container(),
                body: Consumer<StorageProvider>(
                  builder: (context, d, child) {
                    List<Image> imgs = d.images;
                    print(imgs.length);
                    return Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: imgs.length,
                        itemBuilder: (context, index) {
                          return ImageListItem(imgs[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
