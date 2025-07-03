import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/recommentedblogs.dart';
import 'package:inkbloom/View/drawer/aboutus.dart';
import 'package:inkbloom/View/drawer/categoryseleection.dart';
import 'package:inkbloom/View/drawer/privacyandpolicy.dart';
import 'package:inkbloom/View/drawer/settings.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';
import 'package:inkbloom/service/authservice.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? name;
  String? email;
  String? avatar;

  @override
  void initState() {
    super.initState();

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
                    icon: Icons.share,
                    text: "Share App",
                    onTap: () => Share.share('com.example.inkbloom'),
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
