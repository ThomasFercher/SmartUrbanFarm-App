import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/imageListItem.dart';
import 'package:sgs/customwidgets/popupMenu.dart';
import 'package:sgs/customwidgets/timeLapseItem.dart';
import 'package:sgs/customwidgets/timelapseDialog.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/photo.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/objects/timeLapse.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:video_player/video_player.dart';

import '../styles.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String tab = "Photos";

  @override
  void initState() {
    tab = "Photos";
    super.initState();
  }

  List<Widget> getPhotoList(List<Photo> photos) {
    List<Widget> cardlist = [Padding(padding: EdgeInsets.only(top: 15))];
    photos.forEach((element) {
      cardlist.add(ImageListItem(element));
    });
    return cardlist;
  }

  List<Widget> getTimeLapseList(List<TimeLapse> timelapses) {
    List<Widget> cardlist = [Padding(padding: EdgeInsets.only(top: 15))];
    timelapses.forEach((element) {
      cardlist.add(TimeLapseItem(
        timeLapse: element,
      ));
    });
    return cardlist;
  }

  takePhoto() async {
    print("take Photo");
    Provider.of<StorageProvider>(context, listen: false).takePicture();
  }

  createTimeLapse(context) {
    showDialog(
      context: context,
      builder: (context) {
        return TimeLapseDialog();
      },
    );
  }

  Widget timeLapseActionButton(bool isLoading, context) {
    return FloatingActionButton(
      onPressed: () {
        createTimeLapse(context);
      },
        backgroundColor: getTheme().cardColor,
      child: isLoading
          ? Container(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : Icon(
              Icons.timelapse_sharp,
               color: getTheme().primaryColor,
              size: 30,
            ),
    );
  }

  Widget photoActionButton(context) {
    return FloatingActionButton(
      backgroundColor: getTheme().cardColor,
      onPressed: () {
        takePhoto();
      },
      child: Icon(
        Icons.camera,
        color: getTheme().primaryColor,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<StorageProvider>(
      builder: (context, d, child) {
        List<Photo> photos = d.photos;
        List<TimeLapse> timelapses = d.timelapses;
        return AppBarHeader(
          isPage: true,
          theme: getTheme(),
          title: "Gallery",
          trailling: IconButton(
            icon: Icon(Icons.video_collection),
            onPressed: () {},
          ),
          appbarBottom: PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tab = "Photos";
                          });
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(
                                "Photos",
                                style: buttonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tab = "TimeLapses";
                          });
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_collection,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(
                                "TimeLapses",
                                style: buttonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  height: 2,
                  margin: EdgeInsets.only(
                    left: tab == "Photos" ? 0 : width / 2,
                    right: tab == "Photos" ? width / 2 : 0,
                  ),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          actionButton: tab == "Photos"
              ? photoActionButton(context)
              : timeLapseActionButton(d.computingTimelapse, context),
          body: tab == "Photos"
              ? getPhotoList(photos)
              : getTimeLapseList(timelapses),
        );
      },
    );
  }
}
