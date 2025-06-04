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
      colorScheme: ColorScheme.light(
          primary: Colors.grey,
          onPrimary: Colors.white,
          background: Colors.white,
          onBackground: Colors.grey.withOpacity(.3),
          surface: Colors.grey.shade100,
          onSurface: Colors.black87,
          onSecondary: Colors.black),
      brightness: Brightness.light,
      // primaryColor: Colors.black,
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
      colorScheme: ColorScheme.dark(
          error: const Color.fromARGB(255, 147, 58, 58),
          onError: Colors.grey.shade500, //cancel
          primary: Colors.grey, //text color
          onPrimary: Colors.black, //main theme
          background: Colors.black, //light grey theme
          onBackground: Colors.grey.withOpacity(.3),
          surface: Colors.grey.shade900,
          onSurface: Colors.white70,
          onSecondary: Colors.grey),
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.grey),
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
