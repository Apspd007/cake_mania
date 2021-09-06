import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:cake_mania/Widgets/OrderBillCard.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';

class TrackingOrders extends StatefulWidget {
  final String uid;
  TrackingOrders({required this.uid});
  @override
  _TrackingOrdersState createState() => _TrackingOrdersState();
}

class _TrackingOrdersState extends State<TrackingOrders> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _switchTab(),
            StreamBuilder<DocumentSnapshot<Object?>>(
                stream: db.getMyConfirmedOrders(widget.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final json =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final orders = OrderBillModel.jsonToOrderBillList(json);
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: _tabIndex == 0 ? _children(orders) : [],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return SizedBox.shrink();
                  }
                }),
          ],
        ),
      ),
    );
  }

  List<Widget> _children(List<OrderBillModel> orders) {
    final List<Widget> list = [];
    orders.forEach((element) {
      list.add(OrderBillCard(orderBillCard: element));
    });
    return list;
  }

  Align _switchTab() {
    return Align(
      alignment: Alignment.center,
      child: FlutterToggleTab(
        width: 80.w,
        labels: ["Current", "Completed"],
        selectedIndex: _tabIndex,
        selectedLabelIndex: (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
        selectedTextStyle: textStyle(
          color: Colors.black87,
          enableShadow: false,
        ),
        unSelectedTextStyle: textStyle(
          enableShadow: false,
          color: Colors.black54,
        ),
        selectedBackgroundColors: [
          MyColorScheme.aqua,
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      title: Text("Your Orders",
          style: textStyle(
            fontSize: 30,
            enableShadow: false,
          )),
      toolbarHeight: 80.h,
      leadingWidth: 0,
      leading: SizedBox.shrink(),
    );
  }
}
