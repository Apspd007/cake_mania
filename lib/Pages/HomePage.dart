import 'package:badges/badges.dart';
import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/SectionModel.dart';
import 'package:cake_mania/Models/UserSettingsModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Notifiers/SectionNotifier.dart';
import 'package:cake_mania/Other/ConfirmExitDialog.dart';
import 'package:cake_mania/Pages/CheckoutPage.dart';
import 'package:cake_mania/Widgets/CakeSection.dart';
import 'package:cake_mania/Widgets/FancyDrawer.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    // final userSettings = UserPreference.getUserSettings();
    if (mounted) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 1), () => checkIfOrderPaid(context));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  checkIfOrderPaid(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final user = Provider.of<LocalUser>(context, listen: false);
    // print(user.uid);
    db.getPaymentStaus(user.uid, context);
    // print(UserPreference.getUserSettings().notifyPaidOrder);
  }

  @override
  Widget build(BuildContext context) {
    final _totalOrders = context.select<CakeOrderNotifier, int>(
        (cakeOrderNotifier) => cakeOrderNotifier.totalOrders);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => ConfirmExit.showComfirmExitDialog(context),
        child: Scaffold(
          appBar: _appBar(context, _totalOrders),
          drawerEnableOpenDragGesture: true,
          body: Stack(
            children: [
              Image.asset(
                'assets/Background.png',
                fit: BoxFit.cover,
                width: 500.w,
                height: 800.h,
              ),
              _mainBody(context, _totalOrders),
            ],
          ),
        ),
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
              if (sectionModel.cakeModels.length == 0) {
                return SizedBox.shrink();
              } else {
                return CakeSection(
                  title: sectionModel.title,
                  sectionCardColors: sectionModel.cardColor,
                  cardModels: sectionModel.cakeModels,
                );
              }
            } else {
              return SizedBox.shrink();
            }
          } else if (snapshot.hasError) {
            return SizedBox.shrink();
          } else {
            return SizedBox.shrink();
          }
        });
  }

  Widget _mainBody(BuildContext context, int _totalOrders) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _Profile(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _sections(context),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, int totalOrders) {
    final user = Provider.of<LocalUser>(context);
    final auth = Provider.of<AuthBase>(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black54,
      leading: IconButton(
        // icon: Image.asset('assets/Menu.png'),
        icon: SvgPicture.asset(
          'assets/Menu.svg',
          color: MyColorScheme.englishVermillion,
          height: 45.h,
        ),
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, animtaion, secondaryAnimation) {
                  return FancyDrawer(auth: auth, user: user);
                },
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animtaion, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animtaion.drive(
                      Tween(
                        begin: Offset(-1, 0),
                        end: Offset(0, 0),
                      ).chain(CurveTween(
                        curve: Curves.decelerate,
                      )),
                    ),
                    child: child,
                  );
                }),
          );
        },
        splashRadius: 0.001,
      ),
      leadingWidth: 100.w,
      toolbarHeight: 65.h,
      actions: [
        GestureDetector(
          child: SizedBox(
            height: 50.h,
            width: 80.w,
            child: Badge(
              showBadge: totalOrders != 0 ? true : false,
              padding: EdgeInsets.all(8.r),
              badgeContent: Text(totalOrders.toString(),
                  style: lobster2TextStyle(color: Colors.white)),
              badgeColor: Theme.of(context).canvasColor,
              position: BadgePosition.topStart(start: 8.w, top: -5.h),
              child: SvgPicture.asset(
                'assets/Cart.svg',
                height: 45.h,
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (context, animtaion, secondaryAnimation) {
                    return CheckoutPage(user: user);
                  },
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animtaion, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animtaion.drive(
                        Tween(
                          begin: Offset(1, 0),
                          end: Offset(0, 0),
                        ).chain(CurveTween(
                          curve: Curves.decelerate,
                        )),
                      ),
                      child: child,
                    );
                  }),
            );
          },
        ),
      ],
    );
  }
}

class _Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LocalUser>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black26,
          width: .5,
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(_user.displayImage,
                  fit: BoxFit.cover, height: 65.h, width: 65.h),
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
                  style: lobster2TextStyle(fontSize: 22),
                ),
                Text(
                  'What’s Special Today?',
                  style: lobster2TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
