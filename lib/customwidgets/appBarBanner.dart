import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sgs/styles.dart';

class AppBarBanner extends StatelessWidget {
  final maxHeight;
  static double barheight = 30.47619047619048;
  final AppTheme theme;
  AppBarBanner(var maxHeight, this.theme)
      : this.maxHeight = maxHeight + barheight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var height = constraints.maxHeight;
      var width = constraints.maxWidth;
      var h = (height - 80 - barheight) / (maxHeight - 80 - barheight);

      //Opacity
      var h2 = (height - 175 - barheight) / (maxHeight - 175 - barheight);
      var op = h2 > 0 ? h2 : 0.0;

      //Logo Resize
      var h3 = height < 225
          ? (height - 80 - barheight) / (225 - 80 - barheight)
          : 1.0;

      return Container(
        color: Colors.white,
        child: ClipPath(
          clipper: BannerClipper(),
          child: Container(
            color: theme.primaryColor,
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: (width - 50) + 50 * h,
                    height: 80,
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Smart Urban Farm",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: (width / 100) * 8 + 10 * h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: (width / 2 - width / 6) * h3,
                  child: Container(
                    width: (width / 3) * h3 > 80 ? (width / 3) * h3 : 80,
                    //constraints: BoxConstraints(maxHeight: 64),

                    child: Image.asset("assets/images/logobanner.png"),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 5,
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
                  right: 0,
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
          ),
        ),
      );
    });
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
