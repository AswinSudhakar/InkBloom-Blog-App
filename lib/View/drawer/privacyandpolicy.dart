import 'package:flutter/material.dart';
import 'package:wordsview/View/widgets/launchemail.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy&Policy',
            style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 28)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Privacy Policy',
              //   style: theme.textTheme.headlineSmall
              //       ?.copyWith(fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 16),
              const Text(
                'Last updated: May 16, 2025',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                  'WordsView ("we", "our", or "us") values your privacy. This Privacy Policy explains how we collect, use, and protect your personal information when you use our blog application.',
                  style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    fontSize: 16,
                  )),
              const SizedBox(height: 20),
              sectionTitle(
                '1. Information We Collect',
              ),
              sectionBody(
                'We may collect the following information:\n\n'
                '• Personal information (e.g., name, email, profile photo)\n'
                '• Blog content and images you upload\n'
                '• Usage data such as pages visited and interaction logs',
              ),
              const SizedBox(height: 20),
              sectionTitle('2. How We Use Your Information'),
              sectionBody(
                '• To display and manage your blog content\n'
                '• To provide personalized features\n'
                '• To improve app performance and user experience\n'
                '• To communicate with you about updates or promotions',
              ),
              const SizedBox(height: 20),
              sectionTitle('3. Sharing of Information'),
              sectionBody(
                'We do not sell or share your personal information with third parties except when required by law or with your consent.',
              ),
              const SizedBox(height: 20),
              sectionTitle('4. Data Security'),
              sectionBody(
                'We use appropriate security measures to protect your data, but please note that no method of transmission over the internet is 100% secure.',
              ),
              const SizedBox(height: 20),
              sectionTitle('5. Your Choices'),
              sectionBody(
                'You can update or delete your personal information at any time through your profile settings. If you wish to delete your account, please contact our support.',
              ),
              const SizedBox(height: 20),
              sectionTitle('6. Changes to This Policy'),
              sectionBody(
                'We may update this Privacy Policy from time to time. We encourage you to review it periodically.',
              ),
              const SizedBox(height: 20),
              sectionTitle('7. Contact Us'),
              sectionBody(
                  'If you have any questions about this Privacy Policy, you can contact us at:'),
              TextButton(
                  onPressed: () => launchEmail(),
                  child: Text('📧wordsviewblogs@gmail.com',
                      style: TextStyle(
                          fontFamily: 'CrimsonText-Bold',
                          fontSize: 19,
                          color: Theme.of(context).colorScheme.onPrimary)))
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(text,
        style: TextStyle(
          fontFamily: 'CrimsonText-Bold',
          fontSize: 19,
        ));
  }

  Widget sectionBody(String text) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'CrimsonText-Bold', fontSize: 16),
    );
  }
}
