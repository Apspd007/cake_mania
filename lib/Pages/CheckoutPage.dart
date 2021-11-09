import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/DeliveryDetailsModel.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Notifiers/DeliveryModelNotifier.dart';
import 'package:cake_mania/Pages/CongratsPage.dart';
import 'package:cake_mania/Pages/EditDeliveryDetails.dart';
import 'package:cake_mania/Widgets/CakeOrderCard.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class CheckoutPage extends StatefulWidget {
  final LocalUser user;
  CheckoutPage({
    required this.user,
  });
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double totalPrice = 0;
  final String orderId = 'order_${randomNumeric(12)}';
  late Database database;

  // void afterPayment(
  //     {required CakeOrderNotifier cakeOrderNotifier,
  //     required Database database}) {
  //   final json = OrderBillModel.toJson(OrderBillModel(
  //     totalPrice: totalPrice,
  //     orderId: orderId,
  //     cakeOrderModel: cakeOrderNotifier.cakeOrderModel,
  //   ));
  //   database.confirmOrder(widget.user, json, orderId);
  //   cakeOrderNotifier.deleteAllOrders();
  //   UserPreference.clearData();
  //   setState(() {});
  //   Future.delayed(Duration(milliseconds: 250)).then((value) {
  //     Navigator.of(context).popUntil((route) => route.isFirst);
  //   });
  // }

  void _afterPayment(
      {required CakeOrderNotifier cakeOrderNotifier,
      required Database database,
      required DeliveryModelNotifier deliveryNotifier}) {
    final json = OrderBillModel.toJson(OrderBillModel(
      totalPrice: totalPrice,
      orderId: orderId,
      cakeOrderModel: cakeOrderNotifier.cakeOrderModel,
    ));
    database.confirmOrder(
        orderId: orderId,
        order: json,
        user: widget.user,
        deliveryDetails:
            DeliveryDetailsModel.toJson(deliveryNotifier.deliveryModel!));
    cakeOrderNotifier.deleteAllOrders();
    UserPreference.clearOrderData();
    setState(() {});
    Future.delayed(Duration(milliseconds: 250)).then((value) {
      // Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (context, animtaion, secondaryAnimation) {
              return CongratsPage();
            },
            transitionDuration: Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animtaion, secondaryAnimation, child) {
              return SlideTransition(
                position: animtaion.drive(
                  Tween(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                  ).chain(CurveTween(
                    curve: Curves.decelerate,
                  )),
                ),
                child: child,
              );
            }),
      );
    });
  }

  @override
  void didChangeDependencies() {
    double prices = 0;
    final _orders = Provider.of<CakeOrderNotifier>(context);
    _orders.cakeOrderModel.forEach((element) {
      prices += element.price;
    });
    totalPrice = prices;
    database = Provider.of<Database>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DeliveryModelNotifier deliveryNotifier =
        context.watch<DeliveryModelNotifier>();
    return Consumer<CakeOrderNotifier>(builder: (BuildContext context,
        CakeOrderNotifier cakeOrderNotifier, Widget? child) {
      return Scaffold(
        appBar: _appBar(cakeOrderNotifier),
        floatingActionButton: SizedBox(
          height: 70.h,
          width: 250.w,
          child: cakeOrderNotifier.cakeOrderModel.isEmpty
              ? _OrderNow()
              : FloatingActionButton(
                  onPressed: () {
                    if (deliveryNotifier.deliveryModel != null) {
                      Future.delayed(Duration(milliseconds: 200), () {
                        _afterPayment(
                            cakeOrderNotifier: cakeOrderNotifier,
                            database: database,
                            deliveryNotifier: deliveryNotifier);
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content:
                                    Text('You haven\'t Add a delivery Address'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Its fine'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EditDeliveryDetails(
                                                      user: widget.user)));
                                    },
                                    child: Text('Add it now'),
                                  )
                                ],
                              ));
                    }
                  },
                  child: Text(
                    'Confirm Order',
                    style: poppinsTextStyle(fontSize: 25),
                  ),
                  splashColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r)),
                ),
        ),
        body: Stack(
          children: [
            cakeOrderNotifier.cakeOrderModel.isNotEmpty
                ? Image.asset(
                    'assets/Background.png',
                    fit: BoxFit.cover,
                    width: 500.w,
                    height: 800.h,
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _children(cakeOrderNotifier),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _children(CakeOrderNotifier cakeOrderNotifier) {
    List<Widget> children = [];
    if (cakeOrderNotifier.cakeOrderModel.isNotEmpty) {
      children.add(SizedBox(height: 10.h));
      _orders(children, cakeOrderNotifier);
      children.add(SizedBox(height: 25.h));
      children.addAll([
        _grandTotal(),
      ]);
    } else {
      children.add(
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250.r,
                width: double.infinity,
                child: SvgPicture.asset(
                  'assets/Empty_Bag.svg',
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Ohhh... Nothing\'s in the bag!',
                style: poppinsTextStyle(),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Explore around you might find something liking to your taste.',
                  style: poppinsTextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              SizedBox(height: 100.h)
            ],
          ),
        ),
      );
    }
    return children;
  }

  Widget _grandTotal() {
    return Container(
      decoration: BoxDecoration(
          color:Colors.yellow.shade400,
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
          boxShadow: [
            // BoxShadow(
            //   offset: Offset.zero,
            //   color: Colors.black38,
            //   blurRadius: 5.0,
            // ),
          ]),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Grand Total",
              style: lobster2TextStyle(color: Color(0xFF3D3D3D))),
          Text("\u{20B9}" + totalPrice.toString(), style: lobster2TextStyle()),
        ],
      ),
    );
  }

  void _orders(List<Widget> children, CakeOrderNotifier cakeOrderNotifier) {
    int index = 0;
    cakeOrderNotifier.cakeOrderModel.forEach((element) {
      children.add(CakeOrderCard(
        index: index++,
        cakeOrderModel: element,
      ));
    });
  }

  AppBar _appBar(CakeOrderNotifier cakeOrderNotifier) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black54,
      title: Text("Your Cart",
          style: lobster2TextStyle(
            fontSize: 30,
            color: Colors.black87,
          )),
      toolbarHeight: 65.h,
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
      actions: cakeOrderNotifier.cakeOrderModel.isEmpty
          ? []
          : [
              IconButton(
                icon: Icon(
                  Icons.remove_shopping_cart_rounded,
                  size: 35.r,
                  color: MyColorScheme.englishVermillion,
                ),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: 'Cart Cleared',
                    backgroundColor: MyColorScheme.brinkPink,
                    gravity: ToastGravity.CENTER,
                  );
                  cakeOrderNotifier.deleteAllOrders();
                  UserPreference.clearOrderData();
                  setState(() {});
                },
              ),
              SizedBox(width: 10.w),
            ],
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 35.r,
      ),
    );
  }
}

class _OrderNow extends StatelessWidget {
  const _OrderNow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Future.delayed(Duration(milliseconds: 150)).then((value) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      },
      child: Text(
        'Order Now',
        style: poppinsTextStyle(fontSize: 25),
      ),
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    );
  }
}
