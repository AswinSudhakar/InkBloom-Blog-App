import 'package:flutter/material.dart';
import 'package:inkbloom/providers/userprovider.dart';
import 'package:inkbloom/screens/addblog.dart';
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

  Future<void> fetchAndLoadUserData() async {
    // await ProfileService().getUserProfile(); // Ensure profile is fetched
    Provider.of<UserProvider>(context, listen: false).loadData();
    Provider.of<UserProvider>(context, listen: false).fetchandUpdate();
    // await _loadUserData();
  }

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

    fetchAndLoadUserData();
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
              color: Colors.blue.withOpacity(.3),
              width: double.infinity,
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
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
            // User Card
            // UserAccountsDrawerHeader(
            //   accountName: Text(userProvider.name ?? "Guest"),
            //   accountEmail: Text(userProvider.email ?? "No Email"),
            //   currentAccountPicture: GestureDetector(
            //     onTap: () {
            //       // Navigate to User Profile
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const UserProfileScreen()),
            //       );
            //     },
            //     child: CircleAvatar(
            //       backgroundImage: NetworkImage("${userProvider.profileimage}"),
            //     ),
            //   ),
            //   decoration: const BoxDecoration(color: Colors.blue),
            // ),

            // Drawer Items
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Blog"),
              onTap: () {
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
                // );
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
                // );
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

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [IconButton(onPressed: () async {}, icon: Icon(Icons.edit))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 60,
            ),
            const SizedBox(height: 10),

            // Username
            const Text(
              "JohnDoe",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Email
            const Text("user@example.com",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            // Bio
            const Text(
              "UI/UX Designer | Tech Enthusiast",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            // About Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "I love creating beautiful user experiences and working on innovative projects.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
