import 'package:flutter/material.dart';

class IconLabelColumn extends StatelessWidget {
  const IconLabelColumn({
    Key? key,
    required this.icon,
    required this.label,
    this.color = Colors.white,
    this.labelSize = 12,
    this.spacing = 6,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color color;
  final double labelSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        SizedBox(height: spacing),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: labelSize,
          ),
        ),
      ],
    );
  }
}
