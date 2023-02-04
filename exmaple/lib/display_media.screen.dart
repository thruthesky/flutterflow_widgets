import 'package:flutter/material.dart';

class DisplayMediaScreen extends StatefulWidget {
  const DisplayMediaScreen({Key? key}) : super(key: key);

  @override
  State<DisplayMediaScreen> createState() => _DisplayMediaScreenState();
}

class _DisplayMediaScreenState extends State<DisplayMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Media'),
      ),
      body: const Center(
        child: Text('Display Media'),
      ),
    );
  }
}
