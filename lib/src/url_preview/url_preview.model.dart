import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'package:http/http.dart';
import 'package:linkify/linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class UrlPreviewModel {
  /// The input text that may contain a URL.
  String? text;

  String? firstLink;

  /// HTML
  ///
  /// The body of the URL. This is used to extract the meta data.
  String? html;

  String? siteName;
  String? title;
  String? description;
  String? image;

  UrlPreviewModel({
    this.siteName,
    this.title,
    this.description,
    this.image,
  });

  Future load(String? text) async {
    this.text = text;
    firstLink = getFirstLink();
    if (firstLink == null || firstLink!.isEmpty) {
      return;
    }
    html = await getUrlContent();
    if (html != null) {
      parseHtml(html!);
    }
  }

  bool get hasData {
    if (firstLink == null ||
        firstLink!.isEmpty ||
        html == null ||
        html!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  parseHtml(String body) {
    final Document doc = parse(body);

    siteName = getOGTag(doc, 'og:site_name');
    title = getOGTag(doc, 'og:title') ?? getTag(doc, 'title');
    description =
        getOGTag(doc, 'og:description') ?? getMeta(doc, 'description');
    image = getOGTag(doc, 'og:image');
  }

  String? getOGTag(Document document, String parameter) {
    final metaTags = document.getElementsByTagName("meta");
    if (metaTags.isEmpty) return null;
    for (var meta in metaTags) {
      if (meta.attributes['property'] == parameter) {
        return meta.attributes['content']?.replaceAll('\n', " ");
      }
    }
    return null;
  }

  String? getTag(Document document, String tag) {
    final metaTags = document.getElementsByTagName(tag);
    if (metaTags.isEmpty) return null;
    for (var meta in metaTags) {
      return meta.text.replaceAll('\n', " ");
    }
    return null;
  }

  String? getMeta(Document document, String parameter) {
    final metaTags = document.getElementsByTagName("meta");
    if (metaTags.isEmpty) return null;
    for (var meta in metaTags) {
      if (meta.attributes['name'] == parameter) {
        return meta.attributes['content']?.replaceAll('\n', " ");
      }
    }
    return null;
  }

  /// Attempts to extract link from a string.
  ///
  /// If no link is found, then return null.
  String? getFirstLink() {
    List<LinkifyElement> elements = linkify(
      text!,
      options: const LinkifyOptions(
        humanize: false,
      ),
    );

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

  @override
  String toString() {
    return 'UrlPreviewModel{siteName: $siteName, title: $title, description: $description, image: $image}';
  }
}
