// import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:inkbloom/View/authentication/register.dart';

// class Welcomescreen extends StatefulWidget {
//   const Welcomescreen({super.key});

//   @override
//   State<Welcomescreen> createState() => _WelcomescreenState();
// }

// class _WelcomescreenState extends State<Welcomescreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: Image.asset(
//                 "assets/images/orandwh.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Align(
//               alignment: Alignment(.9, .6),
//               child: SizedBox(
//                 width: 250.0,
//                 child: DefaultTextStyle(
//                   style: GoogleFonts.kanit(
//                     textStyle: TextStyle(
//                         color: const Color.fromARGB(255, 49, 48, 48),
//                         fontSize: 23.0,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   child: AnimatedTextKit(
//                     repeatForever: false,
//                     totalRepeatCount: 1,
//                     animatedTexts: [
//                       TypewriterAnimatedText(
//                           'Discover, create, and share captivating blogs on topics that inspire you.'),
//                       TypewriterAnimatedText(
//                         'Whether you are a reader or a writer, InkBloom is your space to explore ideas',
//                       ),

//                       // TypewriterAnimatedText(
//                       //     'Do not test bugs out, design them out'),
//                     ],
//                     onTap: () {
//                       print("Tap Event");
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: const Alignment(-0.6, -0.85),
//               child: DefaultTextStyle(
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                     fontSize: 45.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4.0,
//                         color: Colors.white,
//                         offset: Offset(1.0, 1.0),
//                       ),
//                     ],
//                   ),
//                 ),
//                 child: AnimatedTextKit(
//                   animatedTexts: [
//                     WavyAnimatedText('InkBloom'),
//                   ],
//                   isRepeatingAnimation: true,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment(0, .9),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.deepOrange.withOpacity(0.2),
//                       blurRadius: 12,
//                       spreadRadius: 1,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => RegisterScreen(),
//                         ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrangeAccent,
//                     elevation: 6,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 32, vertical: 18),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     "Get Started",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment(-.6, -.6),
//               child: SizedBox(
//                 width: 250.0,
//                 child: DefaultTextStyle(
//                   style: const TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Bobbers',
//                   ),
//                   child: AnimatedTextKit(
//                     totalRepeatCount: 1,
//                     animatedTexts: [
//                       TyperAnimatedText(
//                           'Discover, create, and share captivating blogs on topics that inspire you.'),
//                     ],
//                     onTap: () {
//                       print("Tap Event");
//                     },
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
