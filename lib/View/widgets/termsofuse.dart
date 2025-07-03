import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inkbloom/View/dialogues/policy_dialogue.dart';

class Termsofuse extends StatelessWidget {
  const Termsofuse({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
            text: 'By Creating An Account You Aggree With Our \n',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: 'CrimsonText-Bold',
            ),
            children: [
              TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () {},
                  text: '     Terms Of Services',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontFamily: 'CrimsonText-Bold',
                  )),
              TextSpan(
                  text: '   And   ',
                  style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                  )),
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialogue(
                              MdfileName: 'privacy_policy.md');
                        },
                      );
                    },
                  text: 'Privacy&Policy',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontFamily: 'CrimsonText-Bold',
                  ))
            ]),
      ),
    );
  }
}
