import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/gallery/dateRangeSelect.dart';
import '../customwidgets/gallery/imageListItem.dart';
import '../customwidgets/gallery/timeLapseItem.dart';
import '../customwidgets/general/appBarHeader.dart';
import '../objects/appTheme.dart';
import '../objects/photo.dart';
import '../objects/timeLapse.dart';
import '../providers/settingsProvider.dart';
import '../providers/storageProvider.dart';
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

  Tween a = new Tween(begin: 0.0, end: 1.0);

  List<Widget> getPhotoList(List<Photo> photos) {
    List<Widget> cardlist = [Padding(padding: EdgeInsets.only(top: 15))];
    photos.forEach((element) {
      cardlist.add(
        TweenAnimationBuilder(
          tween: a,
          duration: Duration(milliseconds: 250),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: (ImageItem(element)),
            );
          },
        ),
      );
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
    Provider.of<StorageProvider>(context, listen: false).takePhoto();
  }

  createTimeLapse(context) {
    showModal(
      configuration: FadeScaleTransitionConfiguration(
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: true,
        reverseTransitionDuration: Duration(milliseconds: 250),
      ),
      context: context,
      builder: (context) {
        return DateRangeSelect();
      },
    );
  }

  Widget timeLapseActionButton(bool isLoading, context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return FloatingActionButton(
      onPressed: () {
        createTimeLapse(context);
      },
      backgroundColor: theme.cardColor,
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
              color: theme.primaryColor,
              size: 30,
            ),
    );
  }

  Widget photoActionButton(context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return FloatingActionButton(
      backgroundColor: theme.cardColor,
      onPressed: () {
        takePhoto();
      },
      child: Icon(
        Icons.camera,
        color: theme.primaryColor,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        var vel = details.velocity.pixelsPerSecond;
        if (vel.dx > 0) {
          setState(() {
            tab = "Photos";
          });
        } else {
          setState(() {
            tab = "TimeLapses";
          });
        }
      },
      child: Consumer<StorageProvider>(
        builder: (context, d, child) {
          List<Photo> photos = d.photos;
          List<TimeLapse> timelapses = d.timelapses;
          List<Widget> tabList = tab == "Photos"
              ? getPhotoList(photos)
              : getTimeLapseList(timelapses);
          return AppBarHeader(
            isPage: true,
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
            body: tabList,
          );
        },
      ),
    );
  }
}
