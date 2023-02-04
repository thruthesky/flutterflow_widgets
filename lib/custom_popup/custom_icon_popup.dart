import 'package:flutter/material.dart';

/// [CustomIconPopup] is a widget that shows a popup when the icon is tapped.
///
class CustomIconPopup extends StatelessWidget {
  const CustomIconPopup({
    Key? key,
    required this.icon,
    required this.popup,
    this.iconPadding = 8,
    this.dx = 0,
    this.dy = 16,
  }) : super(key: key);

  final Icon icon;
  final Widget popup;
  final double iconPadding;
  final double dx;
  final double dy;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      offset: Offset(dx, dy),
      elevation: 0,
      color: Colors.transparent,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            enabled: true,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[popup],
            ),
          ),
        ];
      },
      child: Padding(
        padding: EdgeInsets.all(iconPadding),
        child: icon,
      ),
    );
  }
}
