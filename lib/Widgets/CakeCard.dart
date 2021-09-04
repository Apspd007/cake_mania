import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeModel.dart';
import 'package:cake_mania/Pages/CakeDetails.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

class CakeCard extends StatelessWidget {
  final CakeModel cakeModel;
  final CakeCardColor? cardColor;

  CakeCard({
    required this.cakeModel,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LocalUser>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: GestureDetector(
        onTap: () {
          Get.to(() => CakeDetails(
                cakeModel: cakeModel,
                user: user,
                cardColor: cardColor ?? CakeCardColor.corn,
              ));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            // gradient: _gradient(),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.black38,
                  blurRadius: 15,
                  spreadRadius: 0.5),
            ],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: SizedBox(
              height: 270.h,
              width: 200.w,
              child: Stack(
                children: [
                  _cakeWithDetails(context),
                  // _addToFav(context),
                  _addToBag(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _cardColor(BuildContext context) {
    switch (cardColor) {
      case CakeCardColor.corn:
        return MyColorScheme.corn;
      case CakeCardColor.englishVermillion:
        return MyColorScheme.englishVermillion;
      case CakeCardColor.terraCotta:
        return MyColorScheme.terraCotta;
      default:
        return MyColorScheme.corn;
    }
  }

  // LinearGradient _gradient() {
  //   switch (cardColor) {
  //     case CakeCardColor.corn:
  //       return LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           stops: [
  //             0.2,
  //             0.6,
  //             1.0
  //           ],
  //           colors: [
  //             MyColorScheme.corn.withOpacity(3),
  //             MyColorScheme.corn,
  //             MyColorScheme.corn.withOpacity(7),
  //           ]);
  //     case CakeCardColor.englishVermillion:
  //       return LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           stops: [
  //             0.1,
  //             0.6,
  //             1.0
  //           ],
  //           colors: [
  //             MyColorScheme.englishVermillion.withOpacity(3),
  //             MyColorScheme.englishVermillion,
  //             MyColorScheme.englishVermillion.withOpacity(7),
  //           ]);
  //     default:
  //       return LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           stops: [
  //             0.2,
  //             0.6,
  //             1.0
  //           ],
  //           colors: [
  //             MyColorScheme.corn.withOpacity(3),
  //             MyColorScheme.corn,
  //             MyColorScheme.corn.withOpacity(7),
  //           ]);
  //   }
  // }

  // Color _textColor(BuildContext context) {
  //   switch (cardColor) {
  //     case CakeCardColor.corn:
  //       return MyColorScheme.terraCotta;
  //     case CakeCardColor.englishVermillion:
  //       return Colors.white;
  //     case CakeCardColor.terraCotta:
  //       return Colors.white;
  //     default:
  //       return MyColorScheme.terraCotta;
  //   }
  // }

  // Color _iconColor(BuildContext context) {
  //   switch (cardColor) {
  //     case CakeCardColor.corn:
  //       return Theme.of(context).canvasColor;
  //     case CakeCardColor.englishVermillion:
  //       return Colors.white;
  //     case CakeCardColor.terraCotta:
  //       return Colors.white;
  //     default:
  //       return Theme.of(context).canvasColor;
  //   }
  // }

  Widget _addToBag(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: Alignment.bottomRight,
        child: Icon(
          Icons.add_circle_rounded,
          size: 53.r,
          color: MyColorScheme.englishVermillion,
        ),
      ),
    );
  }

  // Widget _addToFav(BuildContext context) {
  //   final _user = Provider.of<LocalUser>(context);
  //   final _database = Provider.of<Database>(context);
  //   return StreamBuilder<DocumentSnapshot<Object?>>(
  //       stream: _database.getUserDataAsStream(_user.uid),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           final UserData data =
  //               UserData.userDataFromJson(snapshot.data!.data());
  //           return data.favourites.contains(cakeModel.cakeId)
  //               ? GestureDetector(
  //                   onTap: () {
  //                     _database.removeFromFavourite(
  //                         _user.uid, cakeModel.cakeId);
  //                   },
  //                   child: Align(
  //                     alignment: Alignment.topRight,
  //                     child: Icon(
  //                       Icons.favorite,
  //                       size: 33.r,
  //                       color: _iconColor(context),
  //                     ),
  //                   ),
  //                 )
  //               : GestureDetector(
  //                   onTap: () {
  //                     _database.addToFavourite(_user.uid, cakeModel.cakeId);
  //                   },
  //                   child: Align(
  //                     alignment: Alignment.topRight,
  //                     child: Icon(
  //                       Icons.favorite_border_outlined,
  //                       size: 33.r,
  //                       color: _iconColor(context),
  //                     ),
  //                   ),
  //                 );
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text(snapshot.error.toString()));
  //         } else {
  //           return Align(
  //             alignment: Alignment.topRight,
  //             child: Icon(
  //               Icons.favorite_border_outlined,
  //               size: 33.r,
  //               color: _iconColor(context),
  //             ),
  //           );
  //         }
  //       });
  // }

  Align _cakeWithDetails(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: OverflowBox(
        maxHeight: 260.h,
        minHeight: 200.h,
        maxWidth: 180.w,
        minWidth: 150.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: _cardColor(context),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: SimpleShadow(
                      color: Colors.black87,
                      offset: Offset(7, 8),
                      sigma: 4,
                      child: Center(
                        child: ClipRect(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Image.network(
                              cakeModel.imageUrl,
                              height: 150.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cakeModel.name,
                style: textStyle(
                    color: MyColorScheme.englishVermillion,
                    fontWeight: FontWeight.w500,
                    enableShadow: false),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\u{20B9}${cakeModel.price.round().toString()}',
                style: textStyle(
                    color: MyColorScheme.englishVermillion,
                    fontWeight: FontWeight.w500,
                    enableShadow: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
