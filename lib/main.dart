import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/ViewModel/categoryprovider.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/View/additionalscreen/splashscreen.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
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
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
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
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black87),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(backgroundColor: Colors.black),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white70),
      ),
    );

    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeProvider.themeMode,
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
