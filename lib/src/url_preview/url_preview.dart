import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:acx70_widgets/flutterflow_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  final model = UrlPreviewModel();
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await model.load(widget.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text == null ||
        widget.text!.isEmpty ||
        model.firstLink == null ||
        model.firstLink!.isEmpty ||
        model.html == null ||
        model.html!.isEmpty) {
      return const SizedBox.shrink();
    }

    final child =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (model.image != null) CachedNetworkImage(imageUrl: model.image!),
      if (model.title != null) ...[
        const SizedBox(height: 8),
        Text(
          model.title!,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
      if (model.description != null) ...[
        const SizedBox(height: 8),
        Text(
          model.description!.length > (widget.descriptionLength ?? 100)
              ? '${model.description!.substring(0, widget.descriptionLength ?? 100)}...'
              : model.description!,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
        ),
      ],
    ]);
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrlString(model.firstLink!)) {
          await launchUrlString(model.firstLink!);
        } else {
          throw 'Could not launch ${model..firstLink}';
        }
      },
      child: widget.builder(child),
    );
  }
}
