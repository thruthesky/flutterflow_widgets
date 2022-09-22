import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

// create a stateless widget named LinkifyLauncher with a build method containing a Linkify widget and a launchUrlString
class LinkifyLauncher extends StatelessWidget {
  const LinkifyLauncher({Key? key, required this.text}) : super(key: key);
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
