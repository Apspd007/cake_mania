import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? elevation;
  final double width;
  final double height;
  CustomButton({
    required this.onPressed,
    required this.child,
    required this.borderRadius,
    this.elevation = 0.0,
    required this.color,
    this.width = 80,
    this.height = 40,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
