import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:sgs/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeSelect extends StatefulWidget {
  const DateRangeSelect();

  @override
  _DateRangeSelectState createState() => _DateRangeSelectState();
}

class _DateRangeSelectState extends State<DateRangeSelect> {
  DateTimeRange range;
  bool error;

  @override
  void initState() {
    error = false;
    range = DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(1),
        end: DateTime.fromMillisecondsSinceEpoch(1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 300,
              height: 495,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius),
                  ),
                ),
                color: theme.cardColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: borderRadius),
                      child: SectionTitle(
                        title: "Create a Timelapse",
                        fontSize: 24,
                        color: theme.headlineColor,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 370,
                      padding: EdgeInsets.only(
                          top: 16, left: 8, right: 8, bottom: 0),
                      child: SfDateRangePicker(
                        monthCellStyle: DateRangePickerMonthCellStyle(
                          todayTextStyle: TextStyle(color: primaryColor),
                          //  disabledDatesTextStyle:  TextStyle(color: primaryColor),
                          textStyle: TextStyle(color: theme.headlineColor),
                        ),
                        monthViewSettings: DateRangePickerMonthViewSettings(
                          viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(color: theme.headlineColor),
                          ),
                        ),
                        yearCellStyle: DateRangePickerYearCellStyle(
                          textStyle: TextStyle(color: theme.headlineColor),
                          todayTextStyle: TextStyle(color: primaryColor),
                        ),
                        headerStyle: DateRangePickerHeaderStyle(
                          textStyle: TextStyle(color: theme.headlineColor),
                        ),
                        endRangeSelectionColor: primaryColor,
                        startRangeSelectionColor: primaryColor,
                        rangeSelectionColor: primaryColor,
                        selectionColor: primaryColor,
                        todayHighlightColor: primaryColor,
                        selectionShape: DateRangePickerSelectionShape.circle,
                        selectionMode: DateRangePickerSelectionMode.range,
                        onSelectionChanged:
                            (dateRangePickerSelectionChangedArgs) {
                          PickerDateRange r =
                              dateRangePickerSelectionChangedArgs.value;
                          setState(() {
                            range = new DateTimeRange(
                                start: r.startDate ??
                                    DateTime.fromMillisecondsSinceEpoch(1),
                                end: r.endDate ??
                                    DateTime.fromMillisecondsSinceEpoch(1));
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 20,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 400),
                        opacity: error ? 1.0 : 0,
                        child: SectionTitle(
                          title: "Please select a valid Date Range!",
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () => {Navigator.pop(context)},
                            textColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius),
                              ),
                            ),
                            child: Text(
                              "Exit",
                              style: GoogleFonts.nunito(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () => {createTimeLapse()},
                            textColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius),
                              ),
                            ),
                            child: Text(
                              "Create",
                              style: GoogleFonts.nunito(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createTimeLapse() {
    if (range.start != DateTime.fromMillisecondsSinceEpoch(1) &&
        range.end != DateTime.fromMillisecondsSinceEpoch(1)) {
      setState(() {
        error = false;
      });
      Provider.of<StorageProvider>(context, listen: false)
          .createTimelapse(range);

      Navigator.pop(context);
    } else {
      setState(() {
        error = true;
      });
    }
  }
}
