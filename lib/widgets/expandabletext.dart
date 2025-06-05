import 'package:flutter/material.dart';

class StepwiseExpandableText extends StatefulWidget {
  final String text;
  final int linesPerStep;

  const StepwiseExpandableText({
    Key? key,
    required this.text,
    this.linesPerStep = 12,
  }) : super(key: key);

  @override
  _StepwiseExpandableTextState createState() => _StepwiseExpandableTextState();
}

class _StepwiseExpandableTextState extends State<StepwiseExpandableText> {
  late int _currentMaxLines;
  bool _canExpand = false;

  @override
  void initState() {
    super.initState();
    _currentMaxLines = widget.linesPerStep;
  }

  void _increaseLines() {
    setState(() {
      _currentMaxLines += widget.linesPerStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 22,
      fontFamily: 'CrimsonText-SemiBoldItalic',
      color: Theme.of(context).colorScheme.onPrimary,
    );

    final textSpan = TextSpan(
      text: widget.text,
      style: textStyle,
    );

    // Use TextPainter to check if text exceeds the current max lines
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: _currentMaxLines,
      textDirection: TextDirection.ltr,
      ellipsis: '...',
    );

    // Layout with max width of screen to calculate line overflow
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    // Determine if there is more text to expand
    _canExpand = textPainter.didExceedMaxLines;

    return DefaultTextStyle(
      style: textStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: textSpan,
            maxLines: _currentMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          if (_canExpand)
            TextButton(
              onPressed: _increaseLines,
              child: Text(
                'Read More...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
