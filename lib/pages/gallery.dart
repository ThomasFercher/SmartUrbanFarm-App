import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/dropdownMenu.dart';
import 'package:sgs/customwidgets/timelapseDialog.dart';
import 'package:sgs/main.dart';
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

  List<Widget> getImageList(List<Image> imgs) {
    List<Widget> cardlist = [Padding(padding: EdgeInsets.only(top: 15))];
    imgs.forEach((element) {
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

  takePhoto() {
    print("take Photo");
  }

  createTimeLapse(context) {
    showDialog(
      context: context,
      builder: (context) {
        return TimeLapseDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<StorageProvider>(
      builder: (context, d, child) {
        List<Image> imgs = d.images;
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
          actionButton: FloatingActionButton(
            onPressed: () {
              if (tab == "Photos") {
                takePhoto();
              } else if (tab == "TimeLapses") {
                createTimeLapse(context);
              }
            },
            child: Icon(
              tab == "Photos" ? Icons.camera : Icons.timelapse,
              color: primaryColor,
            ),
          ),
          body: tab == "Photos"
              ? getImageList(imgs)
              : getTimeLapseList(timelapses),
        );
      },
    );
  }
}

class ImageListItem extends StatelessWidget {
  final Image image;

  ImageListItem(this.image);

  saveImage(context) async {
    Provider.of<StorageProvider>(context, listen: false).saveImage(image);
  }

  delete(context) {
    Provider.of<StorageProvider>(context, listen: false).deleteImage(image);
  }

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
            Stack(
              children: [
                Container(
                  width: image.width,
                  height: image.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    child: image,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: borderRadius),
                    child: DropDownMenu(
                      actions: ["Save Image", "Delete"],
                      onClicked: (action) {
                        switch (action) {
                          case 'Save Image':
                            saveImage(context);
                            break;
                          case 'Delete':
                            delete(context);
                            break;
                          default:
                        }
                      },
                    ),
                  ),
                )
              ],
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

class TimeLapseItem extends StatefulWidget {
  final TimeLapse timeLapse;

  const TimeLapseItem({Key key, this.timeLapse}) : super(key: key);

  @override
  _TimeLapseItemState createState() => _TimeLapseItemState();
}

class _TimeLapseItemState extends State<TimeLapseItem> {
  VideoPlayerController _controller;
  bool loaded;
  bool videoHasEnded;

  @override
  void initState() {
    super.initState();
    loaded = false;
    videoHasEnded = false;
    _controller = VideoPlayerController.file(widget.timeLapse.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() {
          loaded = true;
        });
      });

    _controller.addListener(() async {
      if (_controller.value.position ==
          Duration(
              microseconds: 0,
              milliseconds: 0,
              seconds: 0,
              minutes: 0,
              hours: 0)) {
        videoHasEnded = false;
      } else if (_controller.value.position == _controller.value.duration &&
          !videoHasEnded) {
        videoHasEnded = true;
        await _controller
            .seekTo(Duration(
                microseconds: 0,
                milliseconds: 0,
                seconds: 0,
                minutes: 0,
                hours: 0))
            .then((value) => _controller.pause());
      }
    });
  }

  saveTimeLapse(context) async {
    Provider.of<StorageProvider>(context, listen: false)
        .saveTimeLapse(widget.timeLapse);
  }

  delete(context) {
    Provider.of<StorageProvider>(context, listen: false)
        .deleteTimeLapse(widget.timeLapse);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width - 30,
      child: Card(
        elevation: cardElavation + 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(borderRadius),
                  child: loaded
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: borderRadius),
                    child: DropDownMenu(
                      actions: ["Save Video", "Delete"],
                      onClicked: (action) {
                        switch (action) {
                          case 'Save Video':
                            saveTimeLapse(context);
                            break;
                          case 'Delete':
                            delete(context);
                            break;
                          default:
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text(
                widget.timeLapse.daterange,
                style: sectionTitleStyle(context, Colors.black87),
              ),
            ),
            ClipRRect(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
              child: Container(
                color: primaryColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            size: 36,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _controller.play();

                            //       _controller.seekTo(Duration(seconds: 0));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            Icons.stop,
                            size: 36,
                            color: Colors.white,
                          ),
                          onPressed: () => {_controller.pause()},
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
