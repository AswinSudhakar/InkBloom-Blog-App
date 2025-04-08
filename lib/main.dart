import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/View/splashscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BlogProvider()..fetchBlogs(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme(),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
