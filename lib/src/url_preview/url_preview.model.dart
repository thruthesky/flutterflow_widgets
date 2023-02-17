import 'package:html/dom.dart';
import 'package:html/parser.dart';

class UrlPreviewModel {
  final String? siteName;
  final String? title;
  final String? description;
  final String? image;

  UrlPreviewModel({
    this.siteName,
    this.title,
    this.description,
    this.image,
  });

  factory UrlPreviewModel.fromBody(String body) {
    final Document doc = parse(body);
    return UrlPreviewModel(
      siteName: getOGTag(doc, 'og:site_name'),
      title: getOGTag(doc, 'og:title'),
      description: getOGTag(doc, 'og:description'),
      image: getOGTag(doc, 'og:image'),
    );
  }

  static String? getOGTag(Document document, String parameter) {
    final metaTags = document.getElementsByTagName("meta");
    if (metaTags.isEmpty) return null;
    for (var meta in metaTags) {
      if (meta.attributes['property'] == parameter) {
        return meta.attributes['content']?.replaceAll('\n', " ");
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'UrlPreviewModel{siteName: $siteName, title: $title, description: $description, image: $image}';
  }
}
