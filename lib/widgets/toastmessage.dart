import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
import 'package:provider/provider.dart';

class CustomToastMessagee {
  static void show({
    Color? color,
    required String message,
    double fontSize = 16.0,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      backgroundColor: color,
      msg: message,
      fontSize: fontSize,
      gravity: gravity,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
