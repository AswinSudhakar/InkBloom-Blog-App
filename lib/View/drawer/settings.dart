import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Settings',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'CrimsonText-Bold'),
          )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ListTile(
            //   title: Text('Dark Mode'),
            //   trailing: Switch(
            //     value: themeProvider.isDarkMode,
            //     onChanged: (value) {
            //       themeProvider.toggleTheme();
            //     },
            //   ),
            // ),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
