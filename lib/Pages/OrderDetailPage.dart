import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_shadow/simple_shadow.dart';

class OrderDetailPage extends StatelessWidget {
  final LocalUser user;
  final OrderBillModel orderModel;
  OrderDetailPage({
    required this.user,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: top + 150.h,
            width: double.infinity,
            color: MyColorScheme.englishVermillion,
            padding: EdgeInsets.fromLTRB(25.r, top + 25.r, 25.r, 25.r),
            child: Row(
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(user.displayImage,
                        fit: BoxFit.cover, height: 100.h, width: 100.h),
                  ),
                ),
                SizedBox(width: 30.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.displayName,
                      style: poppinsTextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Payment: ${orderModel.paymentStatus.toString().split('.')[1].toUpperCase()}',
                      style: poppinsTextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Order: ${orderModel.orderStatus.toString().split('.')[1].toUpperCase()}',
                      style: poppinsTextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: SimpleShadow(
              color: Colors.black87,
              offset: Offset(7, 8),
              sigma: 4,
              child: Image.network(
                orderModel.cakeOrderModel.first.imageUrl,
                height: 150.h,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.only(
                left: 20.w,
                bottom: 20.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    'Cake Id: ${orderModel.cakeOrderModel.first.cakeId}',
                    style: poppinsTextStyle(color: Colors.red.shade500),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Order Id: ${orderModel.orderId}',
                    style: poppinsTextStyle(color: Colors.red.shade500),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Order Time: ${orderModel.orderDate}',
                    style: poppinsTextStyle(color: Colors.red.shade500),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Cake: ${orderModel.cakeOrderModel.first.name}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Price: \u{20B9}${orderModel.cakeOrderModel.first.price}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Flavor: ${orderModel.cakeOrderModel.first.flavor}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Weight: ${orderModel.cakeOrderModel.first.weight}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Occassion: ${orderModel.cakeOrderModel.first.occasion}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Message: ${orderModel.cakeOrderModel.first.message}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Theme: ${orderModel.cakeOrderModel.first.theme}',
                    style: poppinsTextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
