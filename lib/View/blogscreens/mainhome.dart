import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wordsview/View/blogscreens/addblog.dart';
import 'package:wordsview/View/blogscreens/favoritescreen.dart';
import 'package:wordsview/View/blogscreens/home2.dart';
import 'package:wordsview/View/blogscreens/myblogs.dart';
import 'package:wordsview/View/drawer/myaccount.dart';
import 'package:wordsview/ViewModel/blogprovider.dart';
import 'package:wordsview/service/connectivityservice.dart';
import 'package:provider/provider.dart';

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

  Future<bool> _checkRealInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogVisible) return;
    _isDialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'No Internet',
            style: TextStyle(
                fontFamily: 'CrimsonText-Bold',
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          content: Text(
            'You have lost internet connection❗',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'CrimsonText-Bold'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  bool connected = await _checkRealInternet();
                  if (connected) {
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                      _isDialogVisible = false;
                    }
                  }
                } catch (e, stack) {
                  debugPrint("Error in Retry button: $e");
                  debugPrint('$stack');
                }
              },
              child: Text(
                'Retry',
                style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: Text(
                'Exit',
                style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  final provider = BlogProvider();

  @override
  void didPopNext() {
    print("didPopNext called ✅");
    Provider.of<BlogProvider>(context, listen: false).refreshblogs();
    provider.refreshblogs();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _connectivityService.dispose();
    super.dispose();
  }

  int _currentindex = 0;
  final List<int> navigationstack = [0];

  List<Widget> body = [
    HomeScreen2(),
    ProfileScreen(),
    AddBlog(),
    FavoriteScreen(),
    Myblogs()
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigationstack.length > 1) {
          setState(() {
            navigationstack.removeLast();
            _currentindex = navigationstack.last;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Center(
          child: IndexedStack(
            index: _currentindex,
            children: body,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
            unselectedLabelStyle: TextStyle(fontFamily: 'CrimsonText-Bold'),
            currentIndex: _currentindex,
            onTap: (int index) {
              if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBlog(),
                    ));
              } else {
                setState(() {
                  _currentindex = index;
                  navigationstack.add(index);
                });
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Account'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Blog'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.my_library_books), label: 'My Blogs')
            ]),
      ),
    );
  }
}
