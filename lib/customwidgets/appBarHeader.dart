import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class AppBarHeader extends StatelessWidget {
  final String title;
  final Widget trailling;
  final AppTheme theme;
  final Widget body;
  final bool isPage;

  const AppBarHeader({
    this.isPage,
    this.title,
    this.trailling,
    this.theme,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: getTheme().primaryColor,
      ),
      child: Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                color: theme.background[0],
                width: MediaQuery.of(context).size.width,
                height: 80,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isPage
                        ? GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 25,
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                //  Icons.arrow_back_ios_rounded,
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: GoogleFonts.nunito(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      child: trailling,
                    )
                  ],
                ),
              ),
              Container(
                color: theme.primaryColor,
                height: MediaQuery.of(context).size.height - 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
