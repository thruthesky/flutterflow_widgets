import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_widgets/flutterflow_widgets.dart';
import 'package:http/http.dart';
import 'package:linkify/linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:crypto/crypto.dart';

/// [UrlPreview] is a widget that shows a preview of a URL.
///
/// [text] is the text that contains the URL. The first URL in the text is
/// used to generate the preview.
///
/// [descriptionLength] is the length of the description.
///
/// [builder] is a builder function that takes the preview widget as [child]
/// parameter. You can customize the preview widget by using the [builder].
///
class UrlPreview extends StatefulWidget {
  const UrlPreview({
    Key? key,
    this.text,
    this.descriptionLength,
    required this.builder,
  }) : super(key: key);

  final String? text;
  final int? descriptionLength;
  final Widget Function(Widget) builder;

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
      future: getUrlContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            snapshot.hasData == false ||
            snapshot.data.toString().isEmpty) {
          return const SizedBox.shrink();
        }

        final meta = UrlPreviewModel.fromBody(snapshot.data.toString());

        final child =
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (meta.image != null) CachedNetworkImage(imageUrl: meta.image!),
          if (meta.title != null) ...[
            const SizedBox(height: 8),
            Text(
              meta.title!,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ],
          if (meta.description != null) ...[
            const SizedBox(height: 8),
            Text(
              meta.description!.length > (widget.descriptionLength ?? 100)
                  ? '${meta.description!.substring(0, widget.descriptionLength ?? 100)}...'
                  : meta.description!,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
          ],
        ]);
        return GestureDetector(
          onTap: () async {
            if (await canLaunchUrlString(firstLink!)) {
              await launchUrlString(firstLink!);
            } else {
              throw 'Could not launch $firstLink';
            }
          },
          child: widget.builder(child),
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

  Future<String> getUrlContent() async {
    final md5Key = md5.convert(firstLink!.codeUnits).toString();

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    String? html = prefs.getString(md5Key);
    if (html != null) {
      return html;
    }

    final response = await get(Uri.parse(firstLink!));

    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('text/html')) {
      return Future.value('');
    }

    html = response.body;
    // Save an String value to 'action' key.
    await prefs.setString(md5Key, html);
    return Future.value(html);
  }
}
