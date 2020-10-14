import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBanner extends StatelessWidget {
  final maxHeight;
  final String title;
  static double barheight = 30.47619047619048;

  AppBarBanner(var maxHeight, String title)
      : this.maxHeight = maxHeight + barheight,
        this.title = title;

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
        padding: EdgeInsets.only(top: 30),
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
            Positioned(
              bottom: 0,
              left: (width / 2 - width / 6) * h3 > 5
                  ? (width / 2 - width / 6) * h3
                  : 5,
              child: Container(
                width: (width / 3) * h3 > 80 ? (width / 3) * h3 : 80,
                //constraints: BoxConstraints(maxHeight: 64),

                child: Image.asset("assets/images/logobanner.png"),
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
    });
  }
}
