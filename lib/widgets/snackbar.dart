import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
  BuildContext context,
  String? text,
  int color,
) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.all(10.r),
    behavior: SnackBarBehavior.floating,
    content: Text(
      "$text",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16.spMin, color: Colors.white, fontWeight: FontWeight.w500),
    ),
    backgroundColor: Color(color),
  ));
}
