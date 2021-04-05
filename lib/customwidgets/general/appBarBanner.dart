import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../objects/appTheme.dart';
import '../../providers/settingsProvider.dart';

class AppBarBanner extends StatelessWidget {
  final double maxHeight;
  final String title;

  AppBarBanner(this.maxHeight, this.title);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return SafeArea(
      child: Container(
        color: theme.primaryColor,
        constraints: BoxConstraints(maxHeight: maxHeight),
        height: maxHeight,
        child: LayoutBuilder(builder: (context, constraints) {
          var height = constraints.maxHeight;

          var width = constraints.maxWidth;
          var h = (height - 100) / (maxHeight - 100);

          //Opacity
          var h2 = (height - 140) / (maxHeight - 140);
          var op = h2 > 0 ? h2 : 0.0;

          //Logo Resize
          var hi = 1 - h;

          return Container(
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: (width - 50) + 50 * h,
                    height: 80,
                    padding: EdgeInsets.only(left: 20 + hi * 5, right: 20),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 34 + 10 * h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: (width / 2 - width / 6) * h > 5
                      ? (width / 2 - width / 6) * h
                      : 5,
                  child: Container(
                    width: (width / 3) * h > 80 ? (width / 3) * h : 80,
                    //constraints: BoxConstraints(maxHeight: 64),

                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("assets/images/logobanner.png"),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: Opacity(
                    opacity: op,
                    child: Container(
                      width: width / 3,
                      child: Image.asset("assets/images/city.png"),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: Opacity(
                    opacity: op,
                    child: Container(
                      width: width / 3,
                      child: Image.asset("assets/images/city2.png"),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    var h = size.height;
    var w = size.width;
    var r = 20.0;
    path.lineTo(0, 0);
    path.lineTo(0, h);
    path.arcToPoint(Offset(r, h - r), radius: Radius.circular(r));
    path.lineTo(w - r, h - r);
    path.arcToPoint(Offset(w, h), radius: Radius.circular(r));
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
