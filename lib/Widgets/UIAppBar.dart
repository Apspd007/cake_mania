import 'package:cake_mania/Materials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar uiAppBar(
  BuildContext context, {
  required String title,
  required List<Widget> actions,
}) {
  return AppBar(
    title: Text(title,
        style: lobster2TextStyle(
          fontSize: 30,
          color: Colors.black87,
        )),
    backgroundColor: Colors.white,
    elevation: 3,
    shadowColor: Colors.black54,
    toolbarHeight: 65.h,
    actions: actions,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        size: 35.r,
        color: MyColorScheme.englishVermillion,
      ),
    ),
  );
}
