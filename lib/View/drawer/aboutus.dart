import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us',
            style: TextStyle(
              fontFamily: 'CrimsonText-Bold',
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to WordsView!',
                      style: TextStyle(
                          fontFamily: 'CrimsonText-Bold', fontSize: 28)),
                ],
              ),
              const SizedBox(height: 16),
              Text('''
                WordsView is a creative blogging platform designed to give voice to thoughts, stories, and knowledge. Whether you're here to share your ideas or explore what others are saying, we’re committed to providing a clean, engaging, and inspiring experience.''',
                  style:
                      TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 16)),
              const SizedBox(height: 16),
              Text('Our Mission',
                  style:
                      TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 19)),
              const SizedBox(height: 8),
              Text(
                'To empower storytellers and readers through meaningful digital content and a welcoming community.',
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text('Contact Us',
                  style:
                      TextStyle(fontSize: 19, fontFamily: 'CrimsonText-Bold')),
              const SizedBox(height: 8),
              Text(
                '📧 Email: wordsviewblogs@gmail.com \n🌐 Website: www.WordsView.blog',
                style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 16),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text('© 2025 WordsView. All rights reserved.',
                    style: TextStyle(
                        fontFamily: 'CrimsonText-Bold', fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
