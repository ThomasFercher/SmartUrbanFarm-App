import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sgs/customwidgets/appBarBanner.dart';

import '../styles.dart';

class AppBarHeader extends StatelessWidget {
  final String title;
  final Widget trailling;
  final AppTheme theme;
  final List<Widget> body;
  final bool isPage;
  final Widget actionButton;
  final Widget bottomAction;

  bool contentPadding = true;

  AppBarHeader({
    this.isPage,
    this.title,
    this.trailling,
    this.theme,
    this.body,
    this.actionButton,
    contentPadding,
    this.bottomAction,
  }) : contentPadding = contentPadding ?? true;

  @override
  Widget build(BuildContext context) {
    List<SliverListTile> bodyList = body
        .map((e) => SliverListTile(
              child: e,
              hasPadding: contentPadding,
            ))
        .toList();
    /* bodyList.insert(
        0,
        SliverListTile(
          hasPadding: false,
          child: Container(
            color: theme.primaryColor,
            child: Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
            ),
          ),
        ));*/

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        bottomSheet: bottomAction ??
            Container(
              height: 0,
              width: 0,
            ),
        backgroundColor: Colors.white,
        floatingActionButton: actionButton ?? null,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: isPage ? 80 : 240,
              toolbarHeight: 80,
              flexibleSpace: !isPage ? AppBarBanner(240, theme) : Container(),
              floating: true,
              elevation: 0,
              pinned: true,
              snap: true,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: theme.primaryColor,
              leading: isPage
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  : null,
              title: isPage
                  ? Text(
                      title,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    )
                  : null,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: trailling,
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(bodyList),
            ),
          ],
        ),
      ),
    );
  }
}

class DarkPainter extends CustomPainter {
  AppTheme theme = getTheme();
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    /*   var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var height = 200.0;
    var path = new Path();

    paint.color = theme.primaryColor;
    path = new Path();

    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(20);

    canvas.drawOval(Rect.fromLTWH(-100, 100, 200, 400), paint);
    canvas.restore();
    canvas.drawPath(path, paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SliverListTile extends StatelessWidget {
  final Widget child;
  final bool hasPadding;

  const SliverListTile(
      {Key key, @required this.child, @required this.hasPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: hasPadding
            ? const EdgeInsets.symmetric(horizontal: 15.0)
            : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
