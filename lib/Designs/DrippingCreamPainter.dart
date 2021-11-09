import 'package:flutter/material.dart';

class DrippingCreamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1
    paint.color = Color(0xffFF8696);
    path = Path();
    path.lineTo(size.width * 0.07, size.height * 0.75);
    path.cubicTo(size.width * 0.06, size.height * 0.74, size.width * 0.02,
        size.height * 0.70, 0, size.height * 0.64);
    path.cubicTo(0, size.height * 0.77, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.74, size.width,
        size.height * 0.74);
    path.cubicTo(size.width * 0.97, size.height * 0.75, size.width * 0.93,
        size.height * 0.72, size.width * 0.91, size.height * 0.69);
    path.cubicTo(size.width * 0.87, size.height * 0.65, size.width * 0.8,
        size.height * 0.63, size.width * 0.75, size.height * 0.77);
    path.cubicTo(size.width * 0.69, size.height * 0.95, size.width * 0.63,
        size.height * 0.95, size.width * 0.57, size.height * 0.72);
    path.cubicTo(size.width * 0.53, size.height * 0.53, size.width * 0.45,
        size.height * 0.64, size.width * 0.43, size.height * 0.72);
    path.cubicTo(size.width * 0.42, size.height * 0.77, size.width * 0.44,
        size.height * 0.89, size.width * 0.42, size.height * 0.97);
    path.cubicTo(size.width * 0.4, size.height * 1.02, size.width * 0.35,
        size.height, size.width * 0.34, size.height * 0.97);
    path.cubicTo(size.width * 0.31, size.height * 0.91, size.width * 0.34,
        size.height * 0.74, size.width * 0.32, size.height * 0.67);
    path.cubicTo(size.width * 0.3, size.height * 0.6, size.width * 0.24,
        size.height * 0.59, size.width / 4.5, size.height * 0.64);
    path.cubicTo(size.width * 0.18, size.height * 0.75, size.width * 0.16,
        size.height * 0.75, size.width * 0.164, size.height * 0.75);
    path.cubicTo(size.width * 0.12, size.height * 0.80, size.width * 0.08,
        size.height * 0.76, size.width * 0.07, size.height * 0.75);
    path.cubicTo(size.width * 0.07, size.height * 0.75, size.width * 0.07,
        size.height * 0.75, size.width * 0.07, size.height * 0.75);
    canvas.drawPath(path, paint);

    final _path = Path();

    final Paint _paint = Paint();
    _paint.color = Colors.white;
    // Shadow
    canvas.drawShadow(
      _path,
      Colors.black26,
      2,
      true,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DrippingCreamClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    // Path number 1
    path = Path();
    path.lineTo(size.width * 0.07, size.height * 0.75);
    path.cubicTo(size.width * 0.06, size.height * 0.74, size.width * 0.02,
        size.height * 0.70, 0, size.height * 0.64);
    path.cubicTo(0, size.height * 0.77, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.74, size.width,
        size.height * 0.74);
    path.cubicTo(size.width * 0.97, size.height * 0.75, size.width * 0.93,
        size.height * 0.72, size.width * 0.91, size.height * 0.69);
    path.cubicTo(size.width * 0.87, size.height * 0.65, size.width * 0.8,
        size.height * 0.63, size.width * 0.75, size.height * 0.77);
    path.cubicTo(size.width * 0.69, size.height * 0.95, size.width * 0.63,
        size.height * 0.95, size.width * 0.57, size.height * 0.72);
    path.cubicTo(size.width * 0.53, size.height * 0.53, size.width * 0.45,
        size.height * 0.64, size.width * 0.43, size.height * 0.72);
    path.cubicTo(size.width * 0.42, size.height * 0.77, size.width * 0.44,
        size.height * 0.89, size.width * 0.42, size.height * 0.97);
    path.cubicTo(size.width * 0.4, size.height * 1.02, size.width * 0.35,
        size.height, size.width * 0.34, size.height * 0.97);
    path.cubicTo(size.width * 0.31, size.height * 0.91, size.width * 0.34,
        size.height * 0.74, size.width * 0.32, size.height * 0.67);
    path.cubicTo(size.width * 0.3, size.height * 0.6, size.width * 0.24,
        size.height * 0.59, size.width / 4.5, size.height * 0.64);
    path.cubicTo(size.width * 0.18, size.height * 0.75, size.width * 0.16,
        size.height * 0.75, size.width * 0.164, size.height * 0.75);
    path.cubicTo(size.width * 0.12, size.height * 0.80, size.width * 0.08,
        size.height * 0.76, size.width * 0.07, size.height * 0.75);
    path.cubicTo(size.width * 0.07, size.height * 0.75, size.width * 0.07,
        size.height * 0.75, size.width * 0.07, size.height * 0.75);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
