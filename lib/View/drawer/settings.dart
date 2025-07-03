import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inkbloom/View/widgets/launchemail.dart';
import 'package:inkbloom/View/widgets/toastmessage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> openWhatsApp({required String phone, String? message}) async {
      final encodedMessage = Uri.encodeComponent(message ?? "");
      final whatsappUrl = "whatsapp://send?phone=$phone&text=$encodedMessage";

      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        final webUrl = "https://wa.me/$phone?text=$encodedMessage";
        if (await canLaunch(webUrl)) {
          await launch(webUrl);
        } else {
          CustomToastMessagee.show(message: 'Could not launch WhatsApp');
        }
      }
    }

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'CrimsonText-Bold',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                title: Text('Dark Mode', style: TextStyle(fontSize: 18)),
                secondary: Icon(Icons.dark_mode),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  CustomToastMessagee.show(message: 'Theme Changed');
                  themeProvider.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.cleaning_services),
                title: Text('Clear App Data', style: TextStyle(fontSize: 18)),
                subtitle: Text("Long press to reset all saved settings"),
                onLongPress: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.clear();
                  CustomToastMessagee.show(
                    message: 'App Data Cleared',
                  );

                  exit(0);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.support_agent),
                title: Text('Contact Support', style: TextStyle(fontSize: 18)),
                subtitle: Text('wordsviewblogs@gmail.com'),
                onTap: launchEmail,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                title: Text('WhatsApp Us', style: TextStyle(fontSize: 18)),
                subtitle: Text('+1234567890'),
                onTap: () {
                  openWhatsApp(
                      phone: "+1234567890", message: "Hello from WordsView!");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
