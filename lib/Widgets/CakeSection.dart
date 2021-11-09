import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CakeSection extends StatelessWidget {
  final String title;
  final CakeCardColor sectionCardColors;
  final List<CakeModel> cardModels;

  CakeSection({
    required this.title,
    required this.sectionCardColors,
    required this.cardModels,
  });

  @override
  Widget build(BuildContext context) {
    final cards =
        CakeModel.cakeModelListToCakeCardList(cardModels, sectionCardColors);
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black26,
                width: .5,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              title,
              style: lobster2TextStyle(fontSize:25, letterSpacing: 2),
            ),
          ),
          SizedBox(height: 20.h),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cards,
            ),
          )
        ],
      ),
    );
  }
}
