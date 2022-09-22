import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkText extends StatelessWidget {
  const LinkText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) async {
        if (await canLaunchUrlString(link.url)) {
          await launchUrlString(link.url);
        } else {
          throw 'Could not launch $link';
        }
      },
      text: text,
    );
  }
}
