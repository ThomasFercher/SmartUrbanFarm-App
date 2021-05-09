import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../objects/appTheme.dart';
import '../../objects/photo.dart';
import '../../objects/popupMenuOption.dart';
import '../../providers/settingsProvider.dart';
import '../../providers/storageProvider.dart';
import '../../styles.dart';
import '../general/popupMenu.dart';

class ImageItem extends StatelessWidget {
  final Photo photo;

  ImageItem(this.photo);

  saveImage(context) async {
    Provider.of<StorageProvider>(context, listen: false).savePhoto(photo);
  }

  delete(context) {
    Provider.of<StorageProvider>(context, listen: false).deletePhoto(photo);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width - 30,
      child: Card(
        elevation: cardElavation + 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: theme.cardColor,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: photo.image.width,
                  height: photo.image.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    child: photo.image,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenu(
                    color: Colors.white,
                    options: [
                      PopupMenuOption(
                        "Save Image",
                        Icon(Icons.save, color: primaryColor),
                      ),
                      PopupMenuOption(
                        "Delete",
                        Icon(Icons.delete, color: Colors.redAccent),
                      )
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case "Save Image":
                          saveImage(context);
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
                photo.date,
                style: sectionTitleStyle(context, theme.headlineColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
