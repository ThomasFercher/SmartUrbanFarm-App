import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sgs/objects/appTheme.dart';
import '../styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;

  const SectionTitle({
    this.title,
    this.fontSize,
    this.color,
  });

  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
