import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Pages/TrackingOrders.dart';
import 'package:cake_mania/Pages/UserProfile.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FancyDrawer extends StatefulWidget {
  final AuthBase auth;
  final LocalUser user;
  FancyDrawer({
    required this.auth,
    required this.user,
  });
  @override
  _FancyDrawerState createState() => _FancyDrawerState();
}

class _FancyDrawerState extends State<FancyDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sliding1;
  late Animation<double> _sliding2;
  late Animation<double> _sliding3;
  late Animation<double> _sliding4;
  // late Animation<double> _changeInHeight;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
        animationBehavior: AnimationBehavior.preserve);
    _sliding1 = Tween<double>(begin: -500.0, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.3, curve: Curves.decelerate),
    ));
    _sliding2 = Tween<double>(begin: -500.0, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.decelerate),
    ));
    _sliding3 = Tween<double>(begin: -500.0, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.7, curve: Curves.decelerate),
    ));
    _sliding4 = Tween<double>(begin: -500.0, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.9, curve: Curves.decelerate),
    ));
    // _changeInHeight =
    //     Tween<double>(begin: 20.0, end: -20.0).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Interval(0.7, 1.0, curve: Curves.decelerate.flipped),
    // ));
    _controller.forward();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = widget.auth;
    final user = widget.user;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/Background.png',
                  ),
                  fit: BoxFit.cover,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _animation(
                    title: 'Orders',
                    sliding: _sliding4,
                    onTab: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (_) => TrackingOrders(uid: user.uid)));
                      Navigator.of(context).push(
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animtaion, secondaryAnimation) {
                              return TrackingOrders(uid: user.uid);
                            },
                            transitionDuration: Duration(milliseconds: 500),
                            transitionsBuilder: (context, animtaion,
                                secondaryAnimation, child) {
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
                    }),
                SizedBox(height: 20),
                _animation(
                    title: 'Profile',
                    sliding: _sliding3,
                    onTab: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (_) => UserProfile(user: user)));
                      Navigator.of(context).push(
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animtaion, secondaryAnimation) {
                              return UserProfile(user: user);
                            },
                            transitionDuration: Duration(milliseconds: 500),
                            transitionsBuilder: (context, animtaion,
                                secondaryAnimation, child) {
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
                    }),
                SizedBox(height: 20),
                _animation(
                    sliding: _sliding2,
                    title: 'Sign Out',
                    onTab: () {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: 'Comeback Soon!',
                        backgroundColor: MyColorScheme.brinkPink,
                        gravity: ToastGravity.TOP,
                      );
                      UserPreference.saveOrderDetails(context);
                      _auth.signOut();
                    }),
                SizedBox(height: 20),
                _animation(
                    sliding: _sliding1,
                    title: 'Go Back',
                    onTab: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedBuilder _animation(
      {required String title,
      required VoidCallback onTab,
      required Animation<double> sliding}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()..translate(sliding.value, 0.0),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate,
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              width: double.infinity,
              child: GestureDetector(
                onTap: onTab,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: MyColorScheme.corn,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: Text(
                    title,
                    style: lobster2TextStyle(
                      fontSize: 25,
                    ),
                  )),
                ),
              )),
        );
      },
    );
  }
}
