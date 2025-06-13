import 'package:flutter/material.dart';
import 'package:inkbloom/View/drawer/aboutus.dart';
import 'package:inkbloom/View/drawer/categoryseleection.dart';
import 'package:inkbloom/View/drawer/privacyandpolicy.dart';
import 'package:inkbloom/View/drawer/settings.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/service/authservice.dart';
import 'package:inkbloom/widgets/shimmer.dart';
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: Theme.of(context).colorScheme.surface,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: ClipOval(
                      child: userProvider.profileimage != null &&
                              userProvider.profileimage!.isNotEmpty
                          ? Image.network(
                              userProvider.profileimage!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.person, size: 40),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.person, size: 40),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userProvider.name ?? "Guest",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'CrimsonText-Bold'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProvider.email ?? "No Email",
                    style: TextStyle(
                        fontSize: 14,
                        // color: Colors.grey[600],
                        fontFamily: 'CrimsonText-Bold'),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(
                    icon: Icons.category,
                    text: "Suggested Content",
                    onTap: () => _navigateTo(context, const CategoryScreen()),
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    text: "Settings",
                    onTap: () => _navigateTo(context, SettingsScreen()),
                  ),
                  _buildDrawerItem(
                    icon: Icons.privacy_tip,
                    text: "Privacy & Policy",
                    onTap: () =>
                        _navigateTo(context, const PrivacyPolicyPage()),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info,
                    text: "About Us",
                    onTap: () => _navigateTo(context, const AboutUsPage()),
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    text: "Logout",
                    onTap: () => authservice.logOut(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'CrimsonText-Bold',
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:inkbloom/View/drawer/aboutus.dart';
// import 'package:inkbloom/View/drawer/categoryseleection.dart';
// import 'package:inkbloom/View/drawer/privacyandpolicy.dart';
// import 'package:inkbloom/View/drawer/settings.dart';
// import 'package:inkbloom/ViewModel/userprovider.dart';
// import 'package:inkbloom/service/authservice.dart';
// import 'package:provider/provider.dart';

// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   String? name;
//   String? email;
//   String? avatar;

//   // Future<void> fetchAndLoadUserData() async {
//   //   // await ProfileService().getUserProfile(); // Ensure profile is fetched
//   //   Provider.of<UserProvider>(context, listen: false).loadData();
//   //   Provider.of<UserProvider>(context, listen: false).fetchandUpdate();
//   //   // await _loadUserData();
//   // }

//   // Future<void> _loadUserData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     name = prefs.getString('name') ?? " Guest";
//   //     email = prefs.getString('email') ?? "No Email";
//   //     avatar = prefs.getString('avatar') ?? "";
//   //   });
//   // }

//   @override
//   void initState() {
//     super.initState();

//     // fetchAndLoadUserData();
//     Future.delayed(Duration.zero, () {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.loadData();
//       userProvider.fetchandUpdate();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     Authservice authservice = Authservice();
//     return SafeArea(
//       child: Drawer(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               color: Colors.grey.withOpacity(.3),
//               width: double.infinity,
//               height: 180,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // CircleAvatar(
//                   //   radius: 50,
//                   //   backgroundImage: userProvider.profileimage != null &&
//                   //           userProvider.profileimage!.isNotEmpty
//                   //       ? NetworkImage(userProvider.profileimage!)
//                   //       : null,
//                   //   child: userProvider.profileimage == null ||
//                   //           userProvider.profileimage!.isEmpty
//                   //       ? Icon(Icons.person, size: 40)
//                   //       : null,
//                   // ),

//                   SizedBox(
//                     width: 100,
//                     height: 100,
//                     child: ClipOval(
//                       child: userProvider.profileimage != null &&
//                               userProvider.profileimage!.isNotEmpty
//                           ? Image.network(
//                               userProvider.profileimage!,
//                               fit: BoxFit.cover,
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Center(
//                                   child: CircularProgressIndicator(
//                                     value: loadingProgress.expectedTotalBytes !=
//                                             null
//                                         ? loadingProgress
//                                                 .cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                         : null,
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   color: Colors.grey[300],
//                                   alignment: Alignment.center,
//                                   child: const Icon(Icons.person, size: 40),
//                                 );
//                               },
//                             )
//                           : Container(
//                               color: Colors.grey[300],
//                               alignment: Alignment.center,
//                               child: const Icon(Icons.person, size: 40),
//                             ),
//                     ),
//                   ),

//                   Column(
//                     children: [
//                       Text(
//                         userProvider.name ?? "unknown",
//                         style: TextStyle(
//                             fontFamily: 'CrimsonText-SemiBoldItalic',
//                             fontSize: 19),
//                       ),
//                       Text(
//                         userProvider.email ?? "unknown",
//                         style: TextStyle(
//                             fontFamily: 'CrimsonText-SemiBoldItalic',
//                             fontSize: 19),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),

//             // ListTile(
//             //   leading: const Icon(Icons.account_box),
//             //   title: const Text(
//             //     "My Account",
//             //     style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//             //   ),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => ProfileScreen()),
//             //     );
//             //   },
//             // ),
//             // ListTile(
//             //   leading: const Icon(Icons.my_library_books),
//             //   title: const Text(
//             //     "My Blogs",
//             //     style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//             //   ),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => Myblogs()),
//             //     );
//             //   },
//             // ),
//             ListTile(
//               leading: const Icon(Icons.category),
//               title: const Text(
//                 "Suggested Content",
//                 style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const CategoryScreen()),
//                 );
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text(
//                 "Settings",
//                 style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.privacy_tip),
//               title: const Text(
//                 "Privacy&Policy",
//                 style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const PrivacyPolicyPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.details),
//               title: const Text(
//                 "About Us",
//                 style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AboutUsPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text(
//                 "Logout",
//                 style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 21),
//               ),
//               onTap: () {
//                 authservice.logOut(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
