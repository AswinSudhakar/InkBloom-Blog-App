import 'package:flutter/material.dart';
import 'package:inkbloom/View/authentication/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/images/new3.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment(.0, .8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('welcome_shown', true);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                elevation: 6,
                padding:
                    const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
