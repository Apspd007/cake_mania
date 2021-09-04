import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/UserDataModel.dart';
import 'package:cake_mania/Pages/TrackingOrders.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FancyDrawer extends StatefulWidget {
  @override
  _FancyDrawerState createState() => _FancyDrawerState();
}

class _FancyDrawerState extends State<FancyDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _falling;
  late Animation<double> _changeInHeight;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        animationBehavior: AnimationBehavior.preserve);
    _falling = Tween<double>(begin: -800.0, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.9, curve: Curves.decelerate.flipped),
    ));
    _changeInHeight =
        Tween<double>(begin: 20.0, end: -20.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.7, 1.0, curve: Curves.decelerate.flipped),
    ));
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthBase>(context);
    final userData = Provider.of<UserData>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      color: MyColorScheme.brinkPink,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // _animation(
          //     title: 'Favourites',
          //     onTab: () {
          //       Get.to(() => FavoritePage(user: user));
          //     }),
          // SizedBox(height: 20),
          _animation(
              title: 'Orders',
              onTab: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TrackingOrders(
                          userData: userData,
                        )));
              }),
          SizedBox(height: 20),
          _animation(
              title: 'Sign Out',
              onTab: () {
                UserPreference.saveOrderDetails(context);
                _auth.signOut();
              }),
          SizedBox(height: 20),
          _animation(
              title: 'Go Back',
              onTab: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  AnimatedBuilder _animation(
      {required String title, required VoidCallback onTab}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()..translate(0.0, _falling.value),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 60 + _changeInHeight.value.abs(),
              width: double.infinity,
              child: GestureDetector(
                onTap: onTab,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: MyColorScheme.corn,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: Text(title,
                          style: textStyle(
                              fontSize: 25,
                              color: Colors.black87,
                              enableShadow: false))),
                ),
              )),
        );
      },
    );
  }
}
