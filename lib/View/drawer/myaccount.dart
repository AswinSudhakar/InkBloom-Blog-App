import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';

import 'package:inkbloom/View/drawer/editprofile.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> fetchAndLoadUserData() async {
    // await ProfileService().getUserProfile(); // Ensure profile is fetched
    Provider.of<UserProvider>(context, listen: false).loadData();
    Provider.of<UserProvider>(context, listen: false).fetchandUpdate();
    // await _loadUserData();
  }

  // Future<void> _loadUserData() async {
  @override
  void initState() {
    super.initState();

    fetchAndLoadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Name & Profile Pic
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen2(),
                          ));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
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
                                  color: Colors.grey.withOpacity(.3),
                                  child: Icon(Icons.person, size: 40),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 70), // Adjusted to fit avatar

            // Profile Information Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileField(
                      icon: Icons.person, text: '${userProvider.name}'),
                  ProfileField(
                      icon: Icons.email, text: '${userProvider.email}'),
                  SizedBox(height: 20),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Editprofile(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'CrimsonText-Bold'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Profile Fields
class ProfileField extends StatelessWidget {
  final IconData icon;
  final String text;

  final bool isPassword;

  const ProfileField({
    super.key,
    required this.icon,
    required this.text,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(text,
            style: TextStyle(
                fontSize: 16, fontFamily: 'CrimsonText-SemiBoldItalic')),
        trailing: isPassword ? Icon(Icons.sync, color: Colors.grey) : null,
      ),
    );
  }
}
