import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/favoritescreen.dart';
import 'package:inkbloom/View/blogscreens/myblogs.dart';
import 'package:inkbloom/View/drawer/categoryseleection.dart';
import 'package:inkbloom/View/drawer/settings.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/View/blogscreens/addblog.dart';
import 'package:inkbloom/View/drawer/myaccount.dart';
import 'package:inkbloom/service/authservice.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? name;
  String? email;
  String? avatar;

  // Future<void> fetchAndLoadUserData() async {
  //   // await ProfileService().getUserProfile(); // Ensure profile is fetched
  //   Provider.of<UserProvider>(context, listen: false).loadData();
  //   Provider.of<UserProvider>(context, listen: false).fetchandUpdate();
  //   // await _loadUserData();
  // }

  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     name = prefs.getString('name') ?? " Guest";
  //     email = prefs.getString('email') ?? "No Email";
  //     avatar = prefs.getString('avatar') ?? "";
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // fetchAndLoadUserData();
    Future.delayed(Duration.zero, () {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadData();
      userProvider.fetchandUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Authservice authservice = Authservice();
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey.withOpacity(.3),
              width: double.infinity,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // CircleAvatar(
                  //   radius: 50,
                  //   backgroundImage: userProvider.profileimage != null &&
                  //           userProvider.profileimage!.isNotEmpty
                  //       ? NetworkImage(userProvider.profileimage!)
                  //       : null,
                  //   child: userProvider.profileimage == null ||
                  //           userProvider.profileimage!.isEmpty
                  //       ? Icon(Icons.person, size: 40)
                  //       : null,
                  // ),

                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipOval(
                      child: userProvider.profileimage != null &&
                              userProvider.profileimage!.isNotEmpty
                          ? Image.network(
                              userProvider.profileimage!,
                              fit: BoxFit.fill,
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.person, size: 40),
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        userProvider.name ?? "unknown",
                        style: TextStyle(
                            fontFamily: 'CrimsonText-SemiBoldItalic',
                            fontSize: 19),
                      ),
                      Text(
                        userProvider.email ?? "unknown",
                        style: TextStyle(
                            fontFamily: 'CrimsonText-SemiBoldItalic',
                            fontSize: 19),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text(
                "Add Blog",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBlog()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text(
                "My Account",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.my_library_books),
              title: const Text(
                "My Blogs",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Myblogs()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text(
                "Suggested Content",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text(
                "Favorites",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                "Settings",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
              ),
              onTap: () {
                authservice.logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
