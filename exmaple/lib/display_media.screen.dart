import 'package:flutter/material.dart';
import 'package:flutterflow_widgets/flutterflow_widgets.dart';

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
      body: Column(
        children: const [
          Center(
            child: Text('Display Media'),
          ),
          DisplayMedia(
              url:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              width: 200,
              height: 200),
        ],
      ),
    );
  }
}
