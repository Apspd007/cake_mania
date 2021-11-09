import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:cake_mania/Widgets/OrderBillCard.dart';
import 'package:cake_mania/Widgets/UIAppBar.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';

class TrackingOrders extends StatefulWidget {
  final String uid;
  TrackingOrders({required this.uid});
  @override
  _TrackingOrdersState createState() => _TrackingOrdersState();
}

class _TrackingOrdersState extends State<TrackingOrders> {
  bool _showActiveOrders = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Image.asset(
            'assets/Background.png',
            fit: BoxFit.cover,
            width: 500,
            height: 800,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: uiAppBar(
              context,
              title: 'Your Orders',
              actions: [
                IconButton(
                  icon: Icon(
                    // Icons.settings_rounded,
                    Icons.change_circle_outlined,
                    size: 35.r,
                    color: MyColorScheme.englishVermillion,
                  ),
                  onPressed: () {
                    setState(() {
                      _showActiveOrders = !_showActiveOrders;
                    });
                  },
                ),
                SizedBox(width: 10.w),
              ],
            ),
            body: _showActiveOrders
                ? ActiveOrders(uid: widget.uid)
                : CompletedOrders(uid: widget.uid),
          ),
        ],
      ),
    );
  }

}

class ActiveOrders extends StatelessWidget {
  final String uid;
  ActiveOrders({required this.uid});

  List<Widget> _children(List<OrderBillModel> orders) {
    final List<Widget> list = [];
    orders.forEach((element) {
      list.add(OrderBillCard(orderBillCard: element));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: db.getMyConfirmedOrders(uid),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                List<OrderBillModel> orders = [];
                if (snapshot.data!.data() != null) {
                  final json = snapshot.data!.data() as Map<String, dynamic>;
                  orders = OrderBillModel.jsonToOrderBillList(json);
                }
                return Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                                color: MyColorScheme.corn,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Text(
                              'Active Orders',
                              style: lobster2TextStyle(),
                            ),
                          ),
                        ),
                        Column(
                          children: _children(orders),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return nil;
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return nil;
            }
          }),
    );
  }
}

class CompletedOrders extends StatelessWidget {
  final String uid;
  CompletedOrders({required this.uid});

  List<Widget> _children(List<OrderBillModel> orders) {
    final List<Widget> list = [];

    orders.forEach((element) {
      list.add(OrderBillCard(orderBillCard: element));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: db.getMyCompletedOrders(uid),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                List<OrderBillModel> orders = [];
                if (snapshot.data!.data() != null) {
                  final json = snapshot.data!.data() as Map<String, dynamic>;
                  orders = OrderBillModel.jsonToOrderBillList(json);
                }
                return Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                                color: MyColorScheme.corn,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Text(
                              'Completed Orders',
                              style: lobster2TextStyle(),
                            ),
                          ),
                        ),
                        Column(
                          children: _children(orders),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return nil;
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return nil;
            }
          }),
    );
  }
}
