import 'package:flutter/material.dart';

/// [CustomPopup] is a widget that shows a popup when the [child] is tapped.
///
class CustomPopup extends StatelessWidget {
  const CustomPopup({
    Key? key,
    required this.child,
    required this.popup,
    this.dx = 0,
    this.dy = 16,
    this.tooltip = '',
  }) : super(key: key);

  final Widget child;
  final Widget popup;
  final double dx;
  final double dy;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: tooltip,
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
      child: child,
    );
  }
}
