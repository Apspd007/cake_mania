import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Widgets/CakeOrderCard.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _tabbed = false;
  @override
  void initState() {
    super.initState();
  }

  double totalPrice = 0;

  @override
  void didChangeDependencies() {
    double prices = 0;
    final _orders = Provider.of<CakeOrderNotifier>(context);
    _orders.cakeOrderModel.forEach((element) {
      prices += element.price * element.quantity;
    });
    totalPrice = prices;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeOrderNotifier>(builder: (BuildContext context,
        CakeOrderNotifier cakeOrderNotifier, Widget? child) {
      return Scaffold(
        appBar: _appBar(context, cakeOrderNotifier),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _children(cakeOrderNotifier, context),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _children(
      CakeOrderNotifier cakeOrderNotifier, BuildContext context) {
    final String orderId = randomString(12);
    final _dataBase = Provider.of<Database>(context);
    List<Widget> children = [];
    children.add(
      Text(
        'Your Cart',
        style: textStyle(fontSize: 40),
      ),
    );
    children.add(SizedBox(height: 20));
    _orders(children, cakeOrderNotifier);
    children.add(SizedBox(height: 20));
    children.add(
      Divider(
        color: Colors.white,
        endIndent: 25,
        indent: 25,
        height: 5,
        thickness: 4,
      ),
    );
    children.add(SizedBox(height: 20));
    cakeOrderNotifier.cakeOrderModel.isEmpty
        ? children.add(
            _buySomethingButton(
              title: "Buy Something?",
              onTap: () {
                Future.delayed(Duration(milliseconds: 150)).then((value) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              },
            ),
          )
        : children.addAll([
            _confirmOrder(
              cakeOrderModel: cakeOrderNotifier.cakeOrderModel,
              title: "Confirm Order",
              onTap: () {
                final json = OrderBillModel.toJson(OrderBillModel(
                  totalPrice: totalPrice,
                  orderId: orderId,
                  cakeOrderModel: cakeOrderNotifier.cakeOrderModel,
                ));
                _dataBase.confirmOrder(widget.user, json, orderId);
                cakeOrderNotifier.deleteAllOrders();
                UserPreference.clearData();
                setState(() {});
                Future.delayed(Duration(milliseconds: 250)).then((value) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              },
            ),
          ]);
    return children;
  }

  Widget _confirmOrder(
      {required String title,
      required VoidCallback onTap,
      required List<CakeOrderModel> cakeOrderModel}) {
    int i = 0;
    List<Widget> _children = [];
    cakeOrderModel.forEach((element) {
      _children.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(element.name,
                  style: textStyle(
                      color: Color(0xFF3D3D3D),
                      enableShadow: false,
                      fontSize: 21)),
              Text("\u{20B9}" + (element.price * element.quantity).toString(),
                  style: textStyle(
                    color: Color(0xFF3D3D3D),
                    enableShadow: false,
                    fontSize: 21,
                  )),
            ],
          ),
        ),
      );
    });
    _children.add(
      Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Grand Total",
                    style: textStyle(
                        color: Color(0xFF3D3D3D),
                        enableShadow: false,
                        fontSize: 21)),
                Text("\u{20B9}" + totalPrice.toString(),
                    style: textStyle(
                      color: Color(0xFF3D3D3D),
                      enableShadow: false,
                      fontSize: 21,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
    _confirmOrderButton(onTap: onTap, children: _children);
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Color(0xFFF6CBD2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _children,
      ),
    );
  }

  void _confirmOrderButton(
      {required VoidCallback onTap, required List<Widget> children}) {
    children.add(
      Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: 65,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Center(
                  child: Text(
                    "Confirm Order",
                    style: textStyle(
                      color: Colors.red,
                      enableShadow: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buySomethingButton(
      {required String title, required VoidCallback onTap}) {
    return SizedBox(
      height: 150,
      child: Center(
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _tabbed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _tabbed = false;
            });
            onTap();
          },
          child: SizedBox(
            height: 65,
            width: 250,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: _tabbed
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(1, 1),
                            blurRadius: 10,
                            spreadRadius: 3),
                      ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                  child: Text(title,
                      style:
                          textStyle(enableShadow: false, color: Colors.red))),
            ),
          ),
        ),
      ),
    );
  }

  void _orders(List<Widget> children, CakeOrderNotifier cakeOrderNotifier) {
    int index = 0;
    if (cakeOrderNotifier.cakeOrderModel.isNotEmpty) {
      cakeOrderNotifier.cakeOrderModel.forEach((element) {
        children.add(CakeOrderCard(
          index: index++,
          cakeOrderCard: element,
        ));
      });
    } else {
      children.add(SizedBox(
        height: 300,
        width: double.infinity,
        child: Center(
          child: Text('Cart is empty', style: textStyle()),
        ),
      ));
    }
  }

  AppBar _appBar(BuildContext context, CakeOrderNotifier cakeOrderNotifier) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 100,
      leadingWidth: 80,
      leading: Ink(
          child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.close_rounded,
        ),
      )),
      actions: [
        Ink(
          width: 85,
          child: InkWell(
            child: Icon(Icons.remove_shopping_cart_rounded),
            onTap: () {
              cakeOrderNotifier.deleteAllOrders();
              UserPreference.clearData();
              setState(() {});
            },
          ),
        )
      ],
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 45.r,
      ),
    );
  }
}
