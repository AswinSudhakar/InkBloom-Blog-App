import 'package:flutter/material.dart';
import 'package:wordsview/ViewModel/blogprovider.dart';
import 'package:wordsview/ViewModel/categoryprovider.dart';
import 'package:wordsview/ViewModel/themeprovider.dart';
import 'package:wordsview/ViewModel/userprovider.dart';
import 'package:wordsview/View/additionalscreen/splashscreen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BlogProvider(),
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
          error: const Color.fromARGB(255, 230, 146, 140),
          onError: Colors.grey.shade500,
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          onErrorContainer: const Color.fromARGB(255, 153, 224, 226),
          onSecondary: Colors.grey),
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
        error: const Color.fromARGB(255, 230, 146, 140),
        onError: Colors.grey.shade500,
        primary: Colors.black,
        onPrimary: Colors.white,
        surface: Colors.grey.shade900,
        onSurface: Colors.white,
        onSecondary: Colors.grey,
        onErrorContainer: const Color.fromARGB(255, 153, 224, 226),
      ),
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
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
