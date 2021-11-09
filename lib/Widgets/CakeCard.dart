import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeModel.dart';
import 'package:cake_mania/Pages/CakeDetails.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.only(right: 30.w),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CakeDetails(
                    cakeModel: cakeModel,
                    user: user,
                    cardColor: cardColor ?? CakeCardColor.corn,
                  )));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black26,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SizedBox(
              child: _cakeWithDetails(context),
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
      case CakeCardColor.brinkPink:
        return MyColorScheme.brinkPink;
      case CakeCardColor.terraCotta:
        return MyColorScheme.terraCotta;
      default:
        return MyColorScheme.corn;
    }
  }

  // Widget _addToBag(BuildContext context) {
  //   // final _cakeOrderNotifier = Provider.of<CakeOrderNotifier>(context);
  //   return GestureDetector(
  //     onTap: () {
  //       // _cakeOrderNotifier.add(CakeOrderModel(
  //       //   imageUrl: cakeModel.imageUrl,
  //       //   cakeId: cakeModel.cakeId,
  //       //   flavor: 'Mango',
  //       //   name: cakeModel.name,
  //       //   price: cakeModel.price,
  //       //   quantity: 1,
  //       // ));
  //       // Fluttertoast.showToast(
  //       //   msg: 'Added to the Cart',
  //       //   backgroundColor: MyColorScheme.brinkPink,
  //       //   gravity: ToastGravity.CENTER,
  //       // );
  //       // UserPreference.saveOrderDetails(context);
  //     },
  //     child: Align(
  //       alignment: Alignment.bottomRight,
  //       child: Icon(
  //         Icons.add_circle_rounded,
  //         size: 53.r,
  //         color: MyColorScheme.englishVermillion,
  //       ),
  //     ),
  //   );
  // }

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
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 180.h,
                width: 180.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: _cardColor(context),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  child: SimpleShadow(
                    color: Colors.black87,
                    offset: Offset(4, 5),
                    sigma: 2.5,
                    child: Center(
                      child: ClipRect(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
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
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cakeModel.name,
                style: lobster2TextStyle(
                  color: MyColorScheme.englishVermillion,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\u{20B9}${cakeModel.price.toString()}',
                style: lobster2TextStyle(
                  color: MyColorScheme.englishVermillion,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
