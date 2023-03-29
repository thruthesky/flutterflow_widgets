// generate a stateless widget named TextWithLabel with a text and label
import 'package:flutter/material.dart';

class TextWithLabel extends StatelessWidget {
  const TextWithLabel({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(text),
      ],
    );
  }
}
