import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/addblog.dart';
import 'package:inkbloom/View/blogscreens/favoritescreen.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';
import 'package:inkbloom/View/blogscreens/myblogs.dart';
import 'package:inkbloom/View/drawer/myaccount.dart';
import 'package:inkbloom/View/test/hometest.dart';
import 'package:inkbloom/service/connectivityservice.dart';

class Mainhome extends StatefulWidget {
  const Mainhome({super.key});

  @override
  State<Mainhome> createState() => _MainhomeState();
}

class _MainhomeState extends State<Mainhome> {
  late ConnectivityService _connectivityService;
  late StreamSubscription<bool> _subscription;
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _subscription =
        _connectivityService.connectionStatusStream.listen((connected) {
      if (!connected) {
        _showNoInternetDialog();
      } else {
        if (_isDialogVisible) {
          Navigator.of(context, rootNavigator: true).pop();
          _isDialogVisible = false;
        }
      }
    });
  }

  // Force internet re-check using DNS lookup
  Future<bool> _checkRealInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  // Show dialog only if one is not already visible
  void _showNoInternetDialog() {
    if (_isDialogVisible) return;
    _isDialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('No Internet'),
          content: const Text('You have lost internet connection.'),
          actions: [
            TextButton(
              onPressed: () async {
                bool connected = await _checkRealInternet();
                if (connected) {
                  Navigator.of(context, rootNavigator: true).pop();
                  _isDialogVisible = false;
                }
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _connectivityService.dispose();
    super.dispose();
  }

  int _currentindex = 0;
  List<Widget> body = [
    HomeScreen2(),
    ProfileScreen(),
    AddBlog(),
    FavoriteScreen(),
    Myblogs()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _currentindex,
          children: body,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          onTap: (int index) {
            setState(() {
              _currentindex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Blog'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorite'),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_books), label: 'My Blogs')
          ]),
    );
  }
}
