import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class UILoginButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? elevation;
  final String text;
  final double textSize;
  final double width;
  final double height;
  final Widget googleImage;
  UILoginButton({
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderRadius = 5.0,
    this.elevation = 0.0,
    required this.text,
    required this.textSize,
    required this.width,
    required this.height,
    required this.googleImage,
  });
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      borderRadius: borderRadius,
      color: backgroundColor,
      elevation: elevation,
      onPressed: onPressed,
      height: height,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          googleImage,
          Text(
            text,
            style: lobster2TextStyle(
              fontSize: textSize,
              color: Color(0xFFFF7285),
            ),
          ),
        ],
      ),
    );
  }
}
