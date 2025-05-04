import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loginloading extends StatelessWidget {
  const Loginloading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // optional for dark theme
      body: Center(
          child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Lottie.asset(
              'assets/animations/login.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment(0, .5),
            child: Text(
              'logging in...',
              style: TextStyle(
                  fontFamily: 'CrimsonText-Bold',
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      )),
    );
  }
}
