import 'package:flutter/material.dart';

class SafeAreaTop extends StatelessWidget {
  const SafeAreaTop({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 5,
      height: MediaQuery.of(context).viewPadding.top,
      color: Colors.transparent,
    );
  }
}
