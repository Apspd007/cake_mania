import 'package:badges/badges.dart';
import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeModel.dart';
import 'package:cake_mania/Models/SectionModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/Other/ConfirmExitDialog.dart';
import 'package:cake_mania/Pages/CheckoutPage.dart';
import 'package:cake_mania/Widgets/CakeSection.dart';
import 'package:cake_mania/Widgets/FancyDrawer.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _totalOrders = context.select<CakeOrderNotifier, int>(
        (cakeOrderNotifier) => cakeOrderNotifier.totalOrders);
    return WillPopScope(
      onWillPop: () => ConfirmExit.showComfirmExitDialog(context, _scaffoldKey),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: FancyDrawer(),
        drawerEnableOpenDragGesture: true,
        body: _mainBody(context, _totalOrders),
      ),
    );
  }

  List<Widget> _sections(BuildContext context) {
    final _auth = Provider.of<Database>(context);
    final _section = context.watch<SectionNameNotifier>();
    final List<Widget> children = [];
    Widget? widget;
    _section.sectionNames.forEach((element) {
      widget = _futureBuilder(_auth, element);
      children.add(widget!);
    });
    return children;
  }

  Widget _futureBuilder(Database _auth, String sectionName) {
    return FutureBuilder<DocumentSnapshot<Object?>>(
        future: _auth.getSectionData(sectionName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              final json = snapshot.data!.data() as Map<String, dynamic>;
              final sectionModel = SectionModel.fromJson(json);
              return CakeSection(
                title: sectionModel.title,
                sectionCardColors: sectionModel.cardColor,
                cardModels: sectionModel.cakeModels,
              );
            } else {
              return Center();
            }
          } else if (snapshot.hasError) {
            return Center();
          } else {
            return Center();
          }
        });
  }

  CustomScrollView _mainBody(BuildContext context, int _totalOrders) {
    return CustomScrollView(
      slivers: [
        _appBar(context, _totalOrders),
        SliverToBoxAdapter(
          child: _profile(context),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _sections(context),
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _appBar(BuildContext context, int totalOrders) {
    final user = Provider.of<LocalUser>(context);
    return SliverAppBar(
      leading: IconButton(
        icon: Image.asset('assets/Menu.png'),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
        splashRadius: 0.001,
      ),
      leadingWidth: 100.w,
      toolbarHeight: 80.h,
      collapsedHeight: 80.h,
      actions: [
        GestureDetector(
          child: SizedBox(
            height: 50.h,
            width: 80.w,
            child: Badge(
              showBadge: totalOrders != 0 ? true : false,
              padding: EdgeInsets.all(8),
              badgeContent: Text(totalOrders.toString(), style: textStyle()),
              badgeColor: Theme.of(context).canvasColor,
              position: BadgePosition.topStart(start: 8, top: 1),
              child: Image.asset(
                'assets/paper-bag.png',
                scale: 1.1.sp,
              ),
            ),
          ),
          onTap: () {
            Get.to(() => CheckoutPage(
                  user: user,
                ));
          },
        ),
      ],
    );
  }

  Padding _profile(BuildContext context) {
    final _user = Provider.of<LocalUser>(context);
    return Padding(
      padding: EdgeInsets.only(left: 30.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(1.5, 3.5),
                    blurRadius: 4,
                    color: Colors.black38),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(_user.displayImage,
                  fit: BoxFit.cover, height: 55.h, width: 55.h),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey! ${_user.displayName.split(" ")[0]}',
                  style: textStyle(),
                ),
                Text(
                  'What’s Special Today?',
                  style: textStyle(fontSize: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
