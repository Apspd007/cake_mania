import 'dart:ui';
import 'package:cake_mania/Designs/DrippingCreamPainter.dart';
import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proste_shadow_clip/proste_shadow_clip.dart';
import 'package:provider/provider.dart';
import 'package:cake_mania/Designs/painter.dart';
import 'package:cake_mania/Widgets/UIButton.dart';
import 'package:cake_mania/Widgets/UIDialogBox.dart';
import 'package:cake_mania/Designs/WaveClip.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(
      statusBarColor:  Color(0xffFF8696)
    );
    AuthBase _authBase = Provider.of<AuthBase>(context);
    final padding = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(bottom: padding),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/wafer.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // wavesContainer(),
            // drippingCream(),
            SizedBox(
              height: 250.h,
              child: Image.asset(
                'assets/dripping_cream.png',
                fit: BoxFit.cover,
              ),
            ),
            centerText(context),
            loginButton(context, _authBase),
          ],
        ),
      ),
    );
  }

  Container centerText(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: _size.width / 2),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Cake',
                  style: GoogleFonts.pacifico(
                      height: 1,
                      // color: Colors.white,
                      color: MyColorScheme.brinkPink,
                      fontSize: 80.sp,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Colors.white),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Colors.white),
                        Shadow(
                            // topRight
                            offset: Offset(1.5, 1.5),
                            color: Colors.white),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Colors.white),
                      ]),
                ),
                TextSpan(
                    text: '\n   Mania',
                    style: GoogleFonts.pacifico(
                      height: 1,
                      color: MyColorScheme.terraCotta,
                      fontSize: 80.sp,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Colors.white),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Colors.white),
                        Shadow(
                            // topRight
                            offset: Offset(1.5, 1.5),
                            color: Colors.white),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Colors.white),
                      ],
                    ))
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Container loginButton(BuildContext context, AuthBase _authBase) {
    return Container(
      height: 100.h,
      width: 220.h,
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: UILoginButton(
          googleImage: Image.asset(
            'assets/google_logo.png',
            width: 30.r,
            height: 30.r,
          ),
          text: 'Continue',
          textSize: 30.sp,
          height: 80.h,
          width: 200.w,
          // backgroundColor: Color(0xFFFF7285),
          borderRadius: 60,
          onPressed: () async {
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.wifi ||
                connectivityResult == ConnectivityResult.mobile) {
              await _authBase.signInWithGoogle();
            } else if (connectivityResult == ConnectivityResult.none) {
              UIDialog.showUIDialog(
                title: 'No Internet!',
                titleColor: Colors.red[400],
                context: context,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ok',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget drippingCream() {
    return Stack(
      children: [
        ProsteShadowClip(
          clipper: DrippingCreamClipper(),
          shadow: [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 5,
            ),
          ],
          child: Container(
            color: Color(0xffFF8696),
            height: 250.h,
          ),
        ),
      ],
    );
  }

  Container wavesContainer() {
    return Container(
      height: 250.h,
      child: Stack(
        children: [
          CustomPaint(
            painter: SecondShadowPainter(),
            child: Container(
              height: 250.h,
              child: ClipPath(
                clipper: SecondWaveClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 245.h,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: FirstShadowPainter(),
            child: Container(
              height: 230.h,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: MyColorScheme.englishVermillion,
                  height: 225.h,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
