import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loadingscreen extends StatelessWidget {
  const Loadingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Lottie.asset(
          'assets/animations/lottieeee.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      )),
    );
  }
}
