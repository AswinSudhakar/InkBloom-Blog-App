import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Textformfieldwidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? whereToFocus;
  final TextInputType keyboardType;
  final String hintText;
  final IconData icons;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextEditingController? ogPassword;

  const Textformfieldwidget(
      {super.key,
      required this.controller,
      required this.keyboardType,
      required this.focusNode,
      this.whereToFocus,
      required this.hintText,
      required this.icons,
      this.maxLength,
      this.validator,
      required this.isPassword,
      this.ogPassword});

  @override
  Widget build(BuildContext context) {
    final obscureText = ValueNotifier(isPassword);
    return ValueListenableBuilder(
        valueListenable: obscureText,
        builder: (context, obscure, _) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: Colors.amber,
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 1.3.w)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 1.3.w)),
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 17.sp),
                prefixIcon: Icon(
                  icons,
                  color: Colors.black,
                  size: 25.w,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40.w,
                ),
                suffixIcon: isPassword == true
                    ? IconButton(
                        onPressed: () {
                          obscureText.value = !obscure;
                        },
                        icon: obscure
                            ? Icon(
                                Icons.visibility_outlined,
                                size: 20.w,
                              )
                            : Icon(
                                Icons.visibility_off_outlined,
                                size: 20.w,
                              ))
                    : null),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(whereToFocus);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your $hintText";
              } else if (hintText == "Email") {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return "Please enter a valid email";
                }
              } else if (hintText == "Password") {
                if (value.length < 8) {
                  return "Must Above 8 char";
                }
              } else if (hintText == "Confirm Password") {
                if (value.trim() != ogPassword?.text.trim()) {
                  return "Passwords do not match";
                }
              }
              return null;
            },
            obscureText: obscure,
          );
        });
  }
}
