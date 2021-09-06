import 'package:cake_mania/Materials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:flutter/cupertino.dart';

class OrderBillCard extends StatelessWidget {
  final OrderBillModel orderBillCard;
  OrderBillCard({
    required this.orderBillCard,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset.zero,
              blurRadius: 10,
              color: Colors.black45,
            ),
          ]),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
      margin: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: _children(orderBillCard),
          ),
        ],
      ),
    );
  }

  List<Widget> _children(OrderBillModel orderBillCard) {
    List<Widget> list = [];
    orderBillCard.cakeOrderModel.forEach((element) {
      list.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              element.imageUrl,
              height: 50.h,
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  overflow: TextOverflow.fade,
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${element.name}",
                      style: textStyle(
                        enableShadow: false,
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                    // TextSpan(
                    //   text: "(${element.flavor})",
                    //   style: textStyle(
                    //     enableShadow: false,
                    //     fontSize: 19,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                  ],
                )),
                Row(
                  children: [
                    Text(
                      "${element.price} x ${element.quantity}",
                      style: textStyle(
                        enableShadow: false,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      "Total :  ${element.price * element.quantity}",
                      style: textStyle(
                        enableShadow: false,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ));
      list.add(SizedBox(height: 10.h));
    });
    list.add(Divider(
      endIndent: 10,
      indent: 10,
      thickness: 2,
      color: Colors.black54,
    ));
    list.add(
      Padding(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Grand Total :  ${orderBillCard.totalPrice}",
              style: textStyle(
                  enableShadow: false, fontSize: 18, color: Colors.black87),
            ),
            Text(
              "${orderBillCard.orderStatus.toString().split(".")[1]}",
              style: textStyle(
                  enableShadow: false, fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
    return list;
  }
}
