import 'package:flutter/material.dart';
import 'package:flutterflow_widgets/flutterflow_widgets.dart';
import 'package:http/http.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// [UrlPreview] is a widget that shows a preview of a URL.
///
/// [text] is the text that contains the URL. The first URL in the text is
/// used to generate the preview.
///
/// [padding] is the padding of the preview. Use this to give paddings on the
/// preview. Default is 0. This is useful especially when you use it with the
/// Flutterflow. You may still wrap a container and set the width and height
/// and give some padding on the container. But when there is no content on
/// the URL, it should not show anything. And that is what this [padding] is
/// for.
///
/// [descriptionLength] is the length of the description.
///
/// The width and height is adjusted to fit the parent container. So, wrap this
/// with a container and set the parent container's width and height to adjust
/// the size of the preview. You may give more UI effects on the preview in
/// this way like background color, border, etc.
///
///
///
class UrlPreview extends StatefulWidget {
  const UrlPreview({
    Key? key,
    this.text,
    this.padding,
    this.descriptionLength,
  }) : super(key: key);

  final String? text;
  final int? descriptionLength;
  final double? padding;

  @override
  createState() => _UrlPreviewState();
}

class _UrlPreviewState extends State<UrlPreview> {
  @override
  Widget build(BuildContext context) {
    if (widget.text == null || widget.text!.isEmpty || firstLink == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder(
      future: get(Uri.parse(firstLink!)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }

        final response = snapshot.data as Response;
        final contentType = response.headers['content-type'];
        if (contentType == null || !contentType.contains('text/html')) {
          return const SizedBox.shrink();
        }

        final meta = UrlPreviewModel.fromBody(response.body);
        return GestureDetector(
          onTap: () async {
            if (await canLaunchUrlString(firstLink!)) {
              await launchUrlString(firstLink!);
            } else {
              throw 'Could not launch $firstLink';
            }
          },
          child: Padding(
            padding: EdgeInsets.all(widget.padding ?? 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meta.image != null) Image.network(meta.image!),
                if (meta.title != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    meta.title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                if (meta.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    meta.description!.length > (widget.descriptionLength ?? 100)
                        ? '${meta.description!.substring(0, widget.descriptionLength ?? 100)}...'
                        : meta.description!,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Attempts to extract link from a string.
  ///
  /// If no link is found, then return null.
  String? get firstLink {
    List<LinkifyElement> elements = linkify(widget.text!,
        options: const LinkifyOptions(
          humanize: false,
        ));

    for (final e in elements) {
      if (e is LinkableElement) {
        return e.url;
      }
    }
    return null;
  }
}
