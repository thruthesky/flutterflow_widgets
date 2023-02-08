import 'package:exmaple/display_media.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_widgets/flutterflow_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LinkifyText(
                text: 'Address: https://philgo.com Address: https://naver.com',
                style: TextStyle(fontSize: 14),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => DisplayMediaScreen()))),
                child: Text('Display Media'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
