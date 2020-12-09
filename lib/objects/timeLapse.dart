import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLapse {
  final File file;
  final DateTimeRange range;
  final String daterange;

  TimeLapse({
    @required this.file,
    this.range,
    this.daterange,
  });
}
