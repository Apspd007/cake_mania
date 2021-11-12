import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Pages/OrderDetailPage.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:flutter/cupertino.dart';

class OrderBillCard extends StatelessWidget {
  final LocalUser user;
  final OrderBillModel orderBillModel;
  OrderBillCard({
    required this.user,
    required this.orderBillModel,
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
              blurRadius: 2.0,
              color: Colors.black45,
            ),
          ]),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: _children(context, orderBillModel),
          ),
        ],
      ),
    );
  }

  List<Widget> _children(BuildContext context, OrderBillModel orderBillCard) {
    final orderStatus = orderBillCard.orderStatus.toString().split(".")[1];
    final paymentStatus =
        orderBillCard.paymentStatus.toString().split('.')[1].toUpperCase();
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
                          style: lobster2TextStyle(
                            enableShadow: false,
                            fontSize: 24,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    Text(
                      "${element.price} x ${element.weight}",
                      style: lobster2TextStyle(
                        enableShadow: false,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      "Total :  ${element.price}",
                      style: lobster2TextStyle(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Grand Total: ",
                  style: poppinsTextStyle(fontSize: 21),
                ),
                Text(
                  '\u{20B9}${orderBillCard.totalPrice}',
                  style: poppinsTextStyle(fontSize: 21),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment: ',
                  style: poppinsTextStyle(fontSize: 20, color: Colors.black87),
                ),
                Text(
                  paymentStatus,
                  style: poppinsTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _paymentColor(paymentStatus)),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order: ',
                  style: poppinsTextStyle(fontSize: 20, color: Colors.black87),
                ),
                SizedBox(height: 10.h),
                Text(
                  orderStatus.toUpperCase(),
                  style: poppinsTextStyle(
                    fontSize: 20,
                    color: _orderColor(orderStatus),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 250), () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OrderDetailPage(
                                user: user,
                                orderModel: orderBillModel,
                              )));
                    });
                  },
                  child: Text(
                    'See Details',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return list;
  }

  Color? _orderColor(orderStatus) {
    switch (orderStatus) {
      case 'rejected':
        return Colors.red.shade800;
      case 'accepted':
        return Colors.green.shade800;
      case 'onHold':
        return Colors.orange.shade800;
      default:
        return Colors.black87;
    }
  }

  Color? _paymentColor(String paymentStatus) {
    switch (paymentStatus) {
      case 'UNPAID':
        return Colors.red.shade900;

      case 'PAID':
        return Colors.green.shade900;
      default:
        return Colors.amber.shade900;
    }
  }
}
