# FlutterFlow Widgets

- This package is developed for `FlutterFlow`. And you may use in flutter.
- This package contains not only widgets but also some actions that are related with UI design like snackbar.


# LinkText

- This is a simple and handy widget to use display linkified and launchable text. When a user taps, it will open the url in the text. This is a simple combination of `linkify` and `launcher` widgets.


## How to use LinkText

- import `flutterflow_widgets` package and supply `text` property to `LinkText`.

```dart
import 'package:flutterflow_widgets/flutterflow_widgets.dart';

class Linkify extends StatefulWidget {
  const Linkify({
    Key? key,
    this.width,
    this.height,
    this.text,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? text;

  @override
  _LinkifyState createState() => _LinkifyState();
}

class _LinkifyState extends State<Linkify> {
  @override
  Widget build(BuildContext context) {
    return LinkifyText(
      text: widget.text ?? '',
      style: TextStyle(fontSize: 14),
    );
  }
}
```


