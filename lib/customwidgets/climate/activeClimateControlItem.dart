import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveClimateControlItem extends StatelessWidget {
  final String value;
  final String lable;
  final IconData icon;
  final double height;

  const ActiveClimateControlItem(
      {Key key, this.value, this.lable, this.icon, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 38,
            width: 38,
            margin: const EdgeInsets.only(right: 15, bottom: 3, top: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              lable,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
