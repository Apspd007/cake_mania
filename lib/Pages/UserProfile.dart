import 'package:badges/badges.dart';
import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Pages/EditDeliveryDetails.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfile extends StatefulWidget {
  final LocalUser user;
  UserProfile({
    required this.user,
  });
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Size size;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _user = widget.user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: MyColorScheme.brinkPink,
            width: double.infinity,
            height: size.height * 0.4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    alignment: Alignment.topRight,
                    badgeColor: Colors.white,
                    badgeContent: Icon(
                      Icons.edit,
                      color: Colors.black87,
                    ),
                    child: CircleAvatar(
                      // backgroundImage: Image.network(_user.displayImage).image,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          _user.displayImage,
                        ),
                      ),
                      maxRadius: 50,
                    ),
                  ),
                  // name with verified badge
                  // Badge(
                  //   alignment: Alignment.topRight,
                  //   badgeColor: Colors.white,
                  //   padding: EdgeInsets.zero,
                  //   badgeContent: Icon(
                  //     Icons.verified,
                  //     color: Colors.blue,
                  //     size: 20,
                  //   ),
                  //   child: Text(
                  //     _user.displayName,
                  //     style: textStyle(
                  //       enableShadow: false,
                  //       fontSize: 25,
                  //       letterSpacing: 2,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  Text(
                    _user.displayName,
                    style: lobster2TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            color: MyColorScheme.brinkPink,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ink(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EditDeliveryDetails(
                                user: widget.user,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 60.h,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Delivery Details",
                              style: lobster2TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 60.h,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Settings",
                          style: lobster2TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
