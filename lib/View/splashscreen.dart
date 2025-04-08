import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';

import 'package:inkbloom/View/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // 3-second delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve stored token

    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to HomeScreen2
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen2()),
      );
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset(
          //   "assets/images/background.jpg",
          //   fit: BoxFit.cover,
          // ),

          // Dark Overlay for Better Visibility
          // Container(
          //   color: Colors.black.withOpacity(0.4), // Dark overlay for contrast
          // ),

          // Centered App Name
          Center(
            child: Text(
              "InkBloom",
              style: GoogleFonts.playfairDisplay(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Colors.purple, Colors.pink, Colors.orange],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 100.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
