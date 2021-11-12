import 'package:badges/badges.dart';
import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeDetailsNotifier.dart';
import 'package:cake_mania/Models/CakeModel.dart';
import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:cake_mania/Models/UserSettingsModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Pages/CheckoutPage.dart';
import 'package:cake_mania/Widgets/Ingredients.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

bool _ordering = false;
double _drag = 0;
late Size _screenSize;

class CakeDetails extends StatefulWidget {
  final CakeModel cakeModel;
  final CakeCardColor cardColor;
  final LocalUser user;
  CakeDetails({
    required this.cakeModel,
    required this.user,
    required this.cardColor,
  });

  @override
  _CakeDetailsState createState() => _CakeDetailsState();
}

class _CakeDetailsState extends State<CakeDetails>
    with SingleTickerProviderStateMixin {
  late CakeOrderNotifier _cakeOrderNotifier;

  void _validateSelection(
      CakeModel cakeModel, CakeDetailsNotifier detailsNotifier) {
    if (_cakeOrderNotifier.cakeOrderModel.length == 2) {
      Fluttertoast.showToast(
        msg: 'Sorry Can\'t Order More Than 2 Cake',
        backgroundColor: Colors.red[300],
        gravity: ToastGravity.CENTER,
      );
    } else if (detailsNotifier.flavour == null) {
      Fluttertoast.showToast(
        msg: 'Choose a Flavour',
        backgroundColor: Colors.red[300],
        gravity: ToastGravity.CENTER,
      );
    } else if (detailsNotifier.weight == null) {
      Fluttertoast.showToast(
        msg: 'Choose Weight',
        backgroundColor: Colors.red[300],
        gravity: ToastGravity.CENTER,
      );
    } else if (detailsNotifier.occasion == null) {
      Fluttertoast.showToast(
        msg: 'Select a Date',
        backgroundColor: Colors.red[300],
        gravity: ToastGravity.CENTER,
      );
    } else {
      _cakeOrderNotifier.add(CakeOrderModel(
        imageUrl: cakeModel.imageUrl,
        cakeId: cakeModel.cakeId,
        flavor: detailsNotifier.flavour!,
        name: cakeModel.name,
        price: cakeModel.price,
        weight: detailsNotifier.weight!,
        occasion: detailsNotifier.occasion!,
        message: detailsNotifier.message ?? null,
        theme: detailsNotifier.theme ?? null,
      ));
      Fluttertoast.showToast(
        msg: 'Added to the Cart',
        backgroundColor: MyColorScheme.brinkPink,
        gravity: ToastGravity.CENTER,
      );
      UserPreference.saveOrderDetails(context);
    }
  }

  @override
  void didChangeDependencies() {
    _screenSize = MediaQuery.of(context).size;
    _cakeOrderNotifier = context.read<CakeOrderNotifier>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final CakeDetailsNotifier cakeDetailsNotifier =
        context.watch<CakeDetailsNotifier>();
    // final db = Provider.of<Database>(context);
    return Scaffold(
      backgroundColor: _cardColor(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: _ordering
          ? AddToCartFloatingButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 200)).then((value) {
                  _validateSelection(widget.cakeModel, cakeDetailsNotifier);
                });
              },
            )
          : OrderFloatingButton(
              onPressed: () {
                // UserPreference.saveUserSettings(
                //     OrderRelatedSettings(notifyPaidOrder: true, orderId: 'order_813725959656'));
                Future.delayed(Duration(milliseconds: 200), () {
                  setState(() {
                    _ordering = true;
                  });
                });
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/Background.png',
              color: _backgroundColor(),
              fit: BoxFit.cover,
              width: 500,
              height: 800,
            ),
            Positioned(
              child: SizedBox(
                  height: _screenSize.height / 2,
                  width: double.infinity,
                  child: _cakeImage(context)),
            ),
            _ordering
                ? _MakingOrder(cakeModel: widget.cakeModel)
                : GestureDetector(
                    child: _CakeDetailSheet(cakeModel: widget.cakeModel),
                    onVerticalDragUpdate: (dragStartDetails) {
                      _drag += dragStartDetails.delta.dy;
                      setState(() {
                        if (_drag > 0) {
                          _drag = 0;
                        } else if (_drag < -200) {
                          _drag = -200;
                        } else {
                          _drag = _drag;
                        }
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Column _cakeImage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15),
            child: _MyAppBar(
              cardColor: widget.cardColor,
              user: widget.user,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Align(
            alignment: Alignment.topCenter,
            child: SimpleShadow(
              color: Colors.black87,
              offset: Offset(4, 5),
              sigma: 2.5,
              child: ClipRect(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  curve: Curves.easeInOutExpo,
                  height: _ordering ? 200.h : 250.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.network(
                      widget.cakeModel.imageUrl,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _cardColor() {
    switch (widget.cardColor) {
      case CakeCardColor.corn:
        return MyColorScheme.corn;
      case CakeCardColor.brinkPink:
        return MyColorScheme.brinkPink;
      case CakeCardColor.terraCotta:
        return MyColorScheme.terraCotta;
      default:
        return MyColorScheme.corn;
    }
  }

  Color? _backgroundColor() {
    switch (widget.cardColor) {
      case CakeCardColor.corn:
        return MyColorScheme.brinkPink;
      case CakeCardColor.brinkPink:
        return Colors.white;
      case CakeCardColor.terraCotta:
        return Colors.white;
      default:
        return null;
    }
  }
}

class AddToCartFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddToCartFloatingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 250.w,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Text(
          'Add To Cart',
          style: poppinsTextStyle(fontSize: 25.sp),
        ),
        splashColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
    );
  }
}

class OrderFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OrderFloatingButton({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 180.w,
      child: FloatingActionButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        splashColor: Theme.of(context).canvasColor,
        child: Text(
          'Order',
          style: poppinsTextStyle(
            fontSize: 25,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

// ignore: must_be_immutable
class _CakeDetailSheet extends StatelessWidget {
  final CakeModel cakeModel;
  _CakeDetailSheet({
    required this.cakeModel,
  });

  double _dragTo = ((_screenSize.height * 0.45) + _drag);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      transform: Transform.translate(offset: Offset(0, _dragTo)).transform,
      padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 40.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.r),
            topLeft: Radius.circular(40.r),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 5),
                blurRadius: 20,
                spreadRadius: 4),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cakeModel.name, style: lobster2TextStyle(color: Colors.black87)),
          Text('\u{20B9}${cakeModel.price.toString()}',
              style: lobster2TextStyle(color: Colors.black87)),
          SizedBox(height: 20.h),
          Text('Ingredients',
              style: lobster2TextStyle(
                fontSize: 28,
                color: Colors.black87,
              )),
          SizedBox(height: 20.h),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 20.w,
            children: [
              Ingredients(),
              Ingredients(),
              Ingredients(),
              Ingredients(),
            ],
          ),
          SizedBox(height: 20.h),
          Text('Details',
              style: lobster2TextStyle(
                fontSize: 28,
                color: Colors.black87,
              )),
          SizedBox(height: 20.h),
          Text("        " + cakeModel.details,
              style: poppinsTextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  final CakeCardColor cardColor;
  final LocalUser user;
  _MyAppBar({
    required this.user,
    required this.cardColor,
  });

  Color _iconColor(BuildContext context) {
    switch (cardColor) {
      case CakeCardColor.corn:
        return MyColorScheme.englishVermillion;
      case CakeCardColor.brinkPink:
        return Colors.white;
      case CakeCardColor.terraCotta:
        return Colors.white;
      default:
        return Theme.of(context).canvasColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalOrders = context.select<CakeOrderNotifier, int>(
        (cakeOrderNotifier) => cakeOrderNotifier.totalOrders);
    final CakeDetailsNotifier notifier =
        Provider.of<CakeDetailsNotifier>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 45.r,
            color: _iconColor(context),
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            _ordering = false;
            notifier.clearCakeDetails();
            Navigator.of(context).pop();
          },
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 50.h,
              width: 80.w,
              child: Badge(
                showBadge: totalOrders != 0 ? true : false,
                padding: EdgeInsets.all(8),
                badgeContent:
                    Text(totalOrders.toString(), style: lobster2TextStyle()),
                badgeColor: Colors.white,
                position: BadgePosition.topStart(start: 10, top: -16),
                child: SvgPicture.asset(
                  'assets/Cart.svg',
                  height: 45.h,
                ),
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

// ignore: must_be_immutable
class _MakingOrder extends StatelessWidget {
  final CakeModel cakeModel;
  bool move = false;
  _MakingOrder({required this.cakeModel});

  String _formatDate(DateTime date) {
    String dateTime = '';
    switch (date.month) {
      case 1:
        dateTime = 'Jan';
        break;
      case 2:
        dateTime = 'Feb';

        break;
      case 3:
        dateTime = 'Mar';

        break;
      case 4:
        dateTime = 'Apr';

        break;
      case 5:
        dateTime = 'May';

        break;
      case 6:
        dateTime = 'Jun';

        break;
      case 7:
        dateTime = 'Jul';

        break;
      case 8:
        dateTime = 'Aus';

        break;
      case 9:
        dateTime = 'Sep';

        break;
      case 10:
        dateTime = 'Oct';

        break;
      case 11:
        dateTime = 'Nov';

        break;
      case 12:
        dateTime = 'Des';

        break;
      default:
        dateTime = '';
    }
    if (date.day < 10) {
      dateTime += '-0${date.day}';
    } else {
      dateTime += '-${date.day}';
    }
    return dateTime;
  }

  void _selectDate(
      BuildContext context, CakeDetailsNotifier cakeDetailsNotifier) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String? _date;
    String? _timeOfDay;

    if (newDate != null && newTime != null) {
      // _date = '${newDate.year} ${newDate.month} ${newDate.day.}';
      _date = _formatDate(newDate);
      _timeOfDay = newTime.format(context);
      // DateTime _dateTime = DateTime.
    }
    String _dateTime = '$_date ($_timeOfDay)';
    cakeDetailsNotifier.changeDetailOf(occasion: _dateTime);
    print('$_dateTime');
  }

  List<DropdownMenuItem<String>> _flavorList = [
    DropdownMenuItem(
      child: Text('Mango'),
      onTap: () {},
      value: 'Mango',
    ),
    DropdownMenuItem(
      child: Text('Strawberry'),
      onTap: () {},
      value: 'Strawberry',
    ),
  ];
  List<DropdownMenuItem<String>> _weightList = [
    DropdownMenuItem(
      child: Text('1 KG'),
      onTap: () {},
      value: '1 KG',
    ),
    DropdownMenuItem(
      child: Text('2 KG'),
      onTap: () {},
      value: '2 KG',
    ),
    DropdownMenuItem(
      child: Text('5 KG'),
      onTap: () {},
      value: '5 KG',
    ),
    DropdownMenuItem(
      child: Text('10 KG'),
      onTap: () {},
      value: '10 KG',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CakeDetailsNotifier>(builder: (BuildContext context,
        CakeDetailsNotifier cakeDetailsNotifier, Widget? child) {
      return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        move = isKeyboardVisible;
        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SimpleShadow(
                  color: Colors.black54,
                  offset: Offset(0, 0),
                  sigma: 12,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 550),
                    curve: Curves.decelerate,
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    height: move ? 620.h : 420.h,
                    // height: 350,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cakeModel.name,
                                style:
                                    lobster2TextStyle(color: Colors.black87)),
                            Text('\u{20B9}${cakeModel.price.toString()}',
                                style:
                                    lobster2TextStyle(color: Colors.black87)),
                            SizedBox(height: 20.h),
                            _flavorAndWeight(cakeDetailsNotifier),
                            SizedBox(height: 10.h),
                            // Occasion
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Occasion: ',
                                  style: lobster2TextStyle(fontSize: 25),
                                ),
                                Visibility(
                                  visible: cakeDetailsNotifier.occasion == null
                                      ? true
                                      : false,
                                  replacement: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        cakeDetailsNotifier.occasion ==
                                                'null (null)'
                                            ? '(no date)'
                                            : cakeDetailsNotifier.occasion ??
                                                '',
                                        style: lobster2TextStyle(),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _selectDate(
                                                context, cakeDetailsNotifier);
                                          },
                                          icon: Icon(
                                            Icons.change_circle_rounded,
                                            color: Colors.red,
                                            size: 30.r,
                                          ))
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _selectDate(context, cakeDetailsNotifier);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        MyColorScheme.englishVermillion,
                                      ),
                                    ),
                                    child: Text(
                                      'Select',
                                      style: lobster2TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Message
                            Row(
                              children: [
                                Text(
                                  'Message:   ',
                                  style: lobster2TextStyle(fontSize: 25),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    cursorHeight: 30.h,
                                    cursorColor:
                                        MyColorScheme.englishVermillion,
                                    style: lobster2TextStyle(fontSize: 25),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColorScheme
                                                    .englishVermillion))),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        cakeDetailsNotifier.clearFieldFor(
                                            message: true);
                                      } else {
                                        cakeDetailsNotifier.changeDetailOf(
                                            message: value);
                                      }
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                            // Theme
                            Row(
                              children: [
                                Text(
                                  'Theme:      ',
                                  style: lobster2TextStyle(fontSize: 25),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    cursorHeight: 30.h,
                                    cursorColor:
                                        MyColorScheme.englishVermillion,
                                    style: lobster2TextStyle(fontSize: 25),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColorScheme
                                                    .englishVermillion))),
                                    maxLines: 1,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        cakeDetailsNotifier.clearFieldFor(
                                            theme: true);
                                      } else {
                                        cakeDetailsNotifier.changeDetailOf(
                                            theme: value);
                                      }
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //cancel button
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            child: Text(
                              'Cancel',
                              style: lobster2TextStyle(
                                fontSize: 25,
                                textDecoration: TextDecoration.underline,
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 200), () {
                                _ordering = move = false;
                                cakeDetailsNotifier.clearCakeDetails();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      });
    });
  }

  Row _flavorAndWeight(CakeDetailsNotifier cakeDetailsNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 5.h, 15.w, 5.h),
          decoration: BoxDecoration(
            border: Border.all(color: MyColorScheme.englishVermillion),
          ),
          child: DropdownButton<String>(
            icon: SizedBox.shrink(),
            value: cakeDetailsNotifier.flavour,
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Flavor  ',
                    style: lobster2TextStyle(
                      fontSize: 25,
                    )),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 40.r,
                  color: MyColorScheme.englishVermillion,
                ),
              ],
            ),
            dropdownColor: Colors.white,
            style: lobster2TextStyle(fontSize: 25),
            underline: Center(),
            onChanged: (String? flavour) {
              cakeDetailsNotifier.changeDetailOf(flavour: flavour);
            },
            items: _flavorList,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 5.h, 15.w, 5.h),
          decoration: BoxDecoration(
            border: Border.all(color: MyColorScheme.englishVermillion),
          ),
          child: DropdownButton<String>(
            value: cakeDetailsNotifier.weight,
            icon: SizedBox.shrink(),
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weight ', style: lobster2TextStyle(fontSize: 25)),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 40.r,
                  color: MyColorScheme.englishVermillion,
                ),
              ],
            ),
            dropdownColor: Colors.white,
            style: lobster2TextStyle(fontSize: 25),
            underline: SizedBox.shrink(),
            onChanged: (String? weight) {
              cakeDetailsNotifier.changeDetailOf(weight: weight);
            },
            items: _weightList,
          ),
        ),
      ],
    );
  }
}
