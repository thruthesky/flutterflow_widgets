# FlutterFlow Widgets

This package is developed especially for `FlutterFlow`, but you may use in flutter if you wish.


## Widgets

### LinkText

- This is a simple and handy widget to use display linkified and launchable text. When a user taps, it will open the url in the text. This is a simple combination of `linkify` and `launcher` widgets.


#### How to apply

- import `flutterflow_widgets` package and supply `text` property to `LinkText`.

```dart
import 'package:flutterflow_widgets/flutterflow_widgets.dart';

class LinkifyText extends StatefulWidget {
  const LinkifyText({
    Key? key,
    this.width,
    this.height,
    this.text,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? text;

  @override
  _LinkifyTextState createState() => _LinkifyTextState();
}

class _LinkifyTextState extends State<LinkifyText> {
  @override
  Widget build(BuildContext context) {
    return LinkText(
      text: widget.text ?? '',
      style: TextStyle(fontSize: 14),
    );
  }
}
```