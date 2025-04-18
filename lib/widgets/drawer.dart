import 'package:flutter/material.dart';
import 'package:inkbloom/View/settings.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/View/blogscreens/addblog.dart';
import 'package:inkbloom/View/myaccount.dart';
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
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userProvider.profileimage != null &&
                            userProvider.profileimage!.isNotEmpty
                        ? NetworkImage(userProvider.profileimage!)
                        : null,
                    child: userProvider.profileimage == null ||
                            userProvider.profileimage!.isEmpty
                        ? Icon(Icons.person, size: 40)
                        : null,
                  ),
                  Column(
                    children: [
                      Text(userProvider.name ?? "unknown"),
                      Text(userProvider.email ?? "unknown")
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Blog"),
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
              title: const Text("My Account"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const Favoritescreen()),
                //     );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
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
