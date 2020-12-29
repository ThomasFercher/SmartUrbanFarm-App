import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/popupMenu.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/objects/timeLapse.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:video_player/video_player.dart';

import '../styles.dart';

class TimeLapseItem extends StatefulWidget {
  final TimeLapse timeLapse;

  const TimeLapseItem({Key key, this.timeLapse}) : super(key: key);

  @override
  _TimeLapseItemState createState() => _TimeLapseItemState();
}

class _TimeLapseItemState extends State<TimeLapseItem> {
  VideoPlayerController _controller;
  bool videoHasEnded;

  @override
  void initState() {
    super.initState();
    videoHasEnded = false;
    _controller = VideoPlayerController.file(widget.timeLapse.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if (mounted) setState(() {});
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
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return AnimatedOpacity(
      opacity: _controller.value.initialized ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width - 30,
        child: Card(
          elevation: cardElavation + 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: theme.cardColor,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius)),
                    child: _controller.value.initialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenu(
                      color: Colors.white,
                      options: [
                        PopupMenuOption(
                          "Save Timelapse",
                          Icon(
                            Icons.save,
                            color: primaryColor,
                          ),
                        ),
                        PopupMenuOption(
                          "Delete",
                          Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        )
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case "Save Timelapse":
                            saveTimeLapse(context);
                            break;
                          case "Delete":
                            delete(context);
                            break;
                          default:
                        }
                      },
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.timeLapse.name,
                  style: sectionTitleStyle(context, theme.headlineColor),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(borderRadius)),
                child: Container(
                  color: theme.cardColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              size: 36,
                              color: theme.headlineColor,
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
                              Icons.pause,
                              size: 36,
                              color: theme.headlineColor,
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
      ),
    );
  }
}
