import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loadingscreen extends StatelessWidget {
  const Loadingscreen({super.key});

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
              'assets/animations/loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment(0, .5),
            child: Text(
              'Please wait...',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'CrimsonText-Bold'),
            ),
          )
        ],
      )),
    );
  }
}
