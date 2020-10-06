import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const SectionTitle({
    this.title,
    this.fontSize,
  });

  Widget build(BuildContext context) {
    AppTheme theme = getTheme();
    return Container(
      color: Colors.white,
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: theme.secondaryTextColor,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
