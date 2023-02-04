import 'package:flutter/material.dart';

class SafeAreaBottom extends StatelessWidget {
  const SafeAreaBottom({
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
      height: MediaQuery.of(context).viewPadding.bottom,
      color: Colors.transparent,
    );
  }
}
