import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialogue extends StatelessWidget {
  PolicyDialogue({
    super.key,
    this.radius = 8,
    required this.MdfileName,
  }) : assert(MdfileName.contains('.md'),
            'The File Must ContainThe >md Extension');

  final double radius;
  final String MdfileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(radius)),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString('assets/$MdfileName');
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(data: snapshot.data!);
              } else {
                return CircularProgressIndicator();
              }
            },
          )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'CrimsonText-Bold',
                ),
              ))
        ],
      ),
    );
  }
}
