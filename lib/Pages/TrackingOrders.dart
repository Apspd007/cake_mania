import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:cake_mania/Models/UserDataModel.dart';
import 'package:cake_mania/Widgets/OrderBillCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class TrackingOrders extends StatefulWidget {
  final UserData userData;
  TrackingOrders({required this.userData});
  @override
  _TrackingOrdersState createState() => _TrackingOrdersState();
}

class _TrackingOrdersState extends State<TrackingOrders> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _userData = widget.userData;
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _switchTab(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // children: _confirmOrderList(_userData.confirmOrders),
                  children:
                      _tabIndex == 0 ? _children(_userData.confirmOrders) : [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _children(List<OrderBillModel> confirmOrders) {
    final List<Widget> list = [];
    confirmOrders.forEach((element) {
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
