import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/addblog.dart';
import 'package:inkbloom/View/blogscreens/favoritescreen.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';
import 'package:inkbloom/View/blogscreens/myblogs.dart';
import 'package:inkbloom/View/drawer/myaccount.dart';

class Mainhome extends StatefulWidget {
  const Mainhome({super.key});

  @override
  State<Mainhome> createState() => _MainhomeState();
}

class _MainhomeState extends State<Mainhome> {
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
