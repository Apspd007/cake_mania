import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Ingredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Ingredients');
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFC2C2C2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 80.h,
          width: 65.w,
        ),
      ),
    );
  }
}
