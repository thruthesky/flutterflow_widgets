import 'package:flutter/material.dart';

class CustomStyleArrow extends CustomPainter {
  CustomStyleArrow({
    required this.color,
  });
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    const double triangleH = 5;
    const double triangleW = 10.0;
    final double width = size.width;
    final double height = size.height;

    final Path trianglePath = Path()
      ..moveTo(width / 2 - triangleW / 2, height)
      ..lineTo(width / 2, triangleH + height)
      ..lineTo(width / 2 + triangleW / 2, height)
      ..lineTo(width / 2 - triangleW / 2, height);
    canvas.drawPath(trianglePath, paint);
    final BorderRadius borderRadius = BorderRadius.circular(8);
    final Rect rect = Rect.fromLTRB(0, 0, width, height);
    final RRect outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Show the snackbar
showSnackBar(BuildContext context, SnackBar snackBarContent) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBarContent);
}

/// Create the snackbar content
SnackBar snackBarContent({
  required BuildContext context,
  required String title,
  required String message,
  Color backgroundColor = Colors.black,
  Icon icon = const Icon(Icons.check_circle, color: Colors.amber, size: 28),
  Color closeButtonColor = Colors.amber,
  Color arrowBackgroundColor = Colors.white,
  int? seconds,
}) {
  Widget content = Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            icon: Icon(
              Icons.close,
              color: closeButtonColor,
            ),
          ),
        ]),
      ),
      Positioned(
        left: 16,
        top: -8,
        child: CustomPaint(
          painter: CustomStyleArrow(color: arrowBackgroundColor),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: icon,
          ),
        ),
      ),
    ],
  );

  return SnackBar(
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    duration: Duration(seconds: seconds ?? 10),
    content: content,
  );
}

/// Show a snackbar with success icon.
///
/// showModalTopSheet is a custom action that shows a modal top sheet.
/// It can be used to display a snackbar on top.
///
/// [context] is the context of the widget that is calling the action. It is
/// optional. If you don't initialize the AppService, you must pass the context
/// here. And the [context] will be set to the AppService.
///
/// [title] is the title of the snackbar.
///
/// [message] is the message of the snackbar.
snackBarSuccess({
  required BuildContext context,
  required String title,
  required String message,
  int? seconds,
}) {
  showSnackBar(
    context,
    snackBarContent(
      context: context,
      title: title,
      message: message,
      backgroundColor: Colors.black,
      closeButtonColor: Colors.amber,
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
      arrowBackgroundColor: Colors.white,
      seconds: seconds,
    ),
  );
}

/// Show a snackbar with error icon.
///
/// See [snackBarSuccess] for more information.
snackBarWarning({
  required BuildContext context,
  required String title,
  required String message,
  int? seconds,
}) {
  showSnackBar(
    context,
    snackBarContent(
      context: context,
      title: title,
      message: message,
      backgroundColor: Colors.amber.shade700,
      closeButtonColor: Colors.white,
      icon: Icon(Icons.error, color: Colors.amber.shade800, size: 28),
      arrowBackgroundColor: Colors.white,
      seconds: seconds,
    ),
  );
}

/// Show a snackbar with error icon.
///
/// It's just an alias of [snackBarWarning].
snackBarError({
  required BuildContext context,
  required String title,
  required String message,
  int? seconds,
}) {
  snackBarWarning(
    title: title,
    message: message,
    seconds: seconds,
    context: context,
  );
}
