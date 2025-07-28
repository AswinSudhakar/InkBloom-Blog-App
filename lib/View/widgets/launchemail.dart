import 'package:wordsview/View/widgets/toastmessage.dart';
import 'package:url_launcher/url_launcher.dart';

void launchEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'wordsviewblogs@gmail.com',
    queryParameters: {'subject': 'App Support', 'body': 'Hi,'},
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    CustomToastMessagee.show(message: 'No email app found');
  }
}
