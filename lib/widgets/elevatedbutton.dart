import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final double width, height;
  final double elevation;
  final int backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final VoidCallback tap;
  final int borderColor;
  const ElevatedButtonWidget(
      {super.key,
      required this.text,
      required this.height,
      required this.width,
      required this.elevation,
      required this.backgroundColor,
      required this.fontSize,
      required this.textColor,
      required this.borderRadius,
      required this.tap,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: tap,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: Color(borderColor), width: 2))),
        minimumSize: WidgetStatePropertyAll(Size(width, height)),
        elevation: WidgetStatePropertyAll(elevation),
        backgroundColor: WidgetStatePropertyAll(Color(backgroundColor)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize.sp,
        ),
      ),
    );
  }
}
