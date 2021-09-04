import 'package:badges/badges.dart';
import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeCardColor.dart';
import 'package:cake_mania/Models/CakeModel.dart';
import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:cake_mania/Pages/CheckoutPage.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  late Size _screenSize;
  bool _ordering = false;
  String? _flavor;
  double _drag = 0;
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
  int? _quantity;
  List<DropdownMenuItem<int>> _quantityList = [
    DropdownMenuItem(
      child: Text('1'),
      onTap: () {},
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('2'),
      onTap: () {},
      value: 2,
    ),
  ];

  void _validateSelection(
      CakeOrderNotifier _cakeOrderNotifier, CakeModel cakeModel) {
    if (_flavor == null) {
      print('no flavor');
    } else if (_quantity == null) {
      print('no quantity');
    } else {
      _cakeOrderNotifier.add(CakeOrderModel(
        cakeId: cakeModel.cakeId,
        flavor: _flavor!,
        name: cakeModel.name,
        price: cakeModel.price,
        quantity: _quantity!,
      ));
      UserPreference.saveOrderDetails(context);
    }
  }

  @override
  void didChangeDependencies() {
    _screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardColor(context),
      floatingActionButton: _ordering
          ? null
          : FloatingActionButton(
              heroTag: 'makeOrder',
              splashColor: Theme.of(context).canvasColor,
              child: Icon(
                Icons.add_rounded,
                size: 40,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  _ordering = true;
                });
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                  height: _screenSize.height / 2,
                  width: double.infinity,
                  child: _cakeImage(context)),
            ),
            _ordering
                ? _makingOrder(context, widget.cakeModel)
                : GestureDetector(
                    child: _detailSheet(),
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
            child: _appBar(context),
          ),
        ),
        Expanded(
          flex: 8,
          child: Align(
            alignment: Alignment.topCenter,
            child: SimpleShadow(
              color: Colors.black87,
              offset: Offset(7, 8),
              sigma: 4,
              child: ClipRect(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  curve: Curves.easeInOutExpo,
                  height: _ordering ? 200.h : 250.h,
                  child: Image.network(
                    widget.cakeModel.imageUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _appBar(BuildContext context) {
    final totalOrders = context.select<CakeOrderNotifier, int>(
        (cakeOrderNotifier) => cakeOrderNotifier.totalOrders);
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 0.001,
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
                badgeContent: Text(totalOrders.toString(), style: textStyle()),
                badgeColor: Theme.of(context).canvasColor,
                position: BadgePosition.topStart(start: 10, top: -16),
                child: Image.asset(
                  'assets/paper-bag.png',
                  scale: 1.sp,
                ),
              ),
            ),
          ),
          onTap: () {
            Get.to(() => CheckoutPage(
                  user: widget.user,
                ));
          },
        ),
      ],
    );
  }

  Color _iconColor(BuildContext context) {
    switch (widget.cardColor) {
      case CakeCardColor.corn:
        return Theme.of(context).canvasColor;
      case CakeCardColor.englishVermillion:
        return Colors.white;
      case CakeCardColor.terraCotta:
        return Colors.white;
      default:
        return Theme.of(context).canvasColor;
    }
  }

  Widget _makingOrder(BuildContext context, CakeModel cakeModel) {
    final _cakeOrderNotifier = context.read<CakeOrderNotifier>();
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Ink(
            width: double.infinity,
            height: 120,
            child: InkWell(
              overlayColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).canvasColor),
              highlightColor: Colors.transparent,
              onTap: () {
                Future.delayed(Duration(milliseconds: 200)).then((value) {
                  _validateSelection(_cakeOrderNotifier, cakeModel);
                });
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 75,
                  child: Center(
                    child: Text(
                      'Add to bag',
                      style: textStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.black87,
                          enableShadow: false),
                    ),
                  ),
                ),
              ),
            ),
            color: Theme.of(context).accentColor,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleShadow(
                color: Colors.black87,
                offset: Offset(0, 0),
                sigma: 12,
                child: Container(
                  height: 350.h,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.cakeModel.name,
                              style: textStyle(color: Colors.black87)),
                          Text(
                              '\u{20B9}${widget.cakeModel.price.round().toString()}',
                              style: textStyle(color: Colors.black87)),
                          SizedBox(height: 20.h),
                          _flavorAndQuantity(),
                          SizedBox(height: 20.h),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Add ons   ',
                                style: textStyle(color: Colors.black87)),
                            TextSpan(
                                text: 'clear',
                                style: textStyle(
                                    color: Colors.blueAccent.shade700,
                                    fontSize: 18.sp,
                                    textDecoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('clear addons');
                                  }),
                          ])),
                          SizedBox(height: 20.h),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 20.w,
                            children: [
                              _ingredients(onTap: () {
                                print('Add ons');
                              }),
                              _ingredients(onTap: () {
                                print('Add ons');
                              }),
                              _ingredients(onTap: () {
                                print('Add ons');
                              }),
                              _ingredients(onTap: () {
                                print('Add ons');
                              }),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Icon(
                            Icons.close_rounded,
                            size: 40.r,
                            color: Theme.of(context).canvasColor,
                          ),
                          onTap: () {
                            setState(() {
                              _ordering = false;
                              _flavor = null;
                              _quantity = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Row _flavorAndQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(13.w, 5.h, 13.w, 5.h),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).canvasColor),
          ),
          child: DropdownButton<String>(
            icon: SizedBox.shrink(),
            value: _flavor,
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Flavor  ',
                    style:
                        textStyle(color: Colors.black87, enableShadow: false)),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 40.r,
                  color: Theme.of(context).canvasColor,
                ),
              ],
            ),
            dropdownColor: Colors.white,
            style: textStyle(color: Colors.black87, enableShadow: false),
            underline: Center(),
            onChanged: (String? flavor) {
              setState(() {
                _flavor = flavor;
              });
            },
            items: _flavorList,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10.w, 5.h, 0, 5.h),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).canvasColor),
          ),
          child: DropdownButton<int>(
            value: _quantity,
            icon: SizedBox.shrink(),
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity ',
                    style:
                        textStyle(color: Colors.black87, enableShadow: false)),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 40,
                  color: Theme.of(context).canvasColor,
                ),
              ],
            ),
            dropdownColor: Colors.white,
            style: textStyle(color: Colors.black87, enableShadow: false),
            underline: Center(),
            onChanged: (int? quantity) {
              setState(() {
                _quantity = quantity;
              });
            },
            items: _quantityList,
          ),
        ),
      ],
    );
  }

  Widget _detailSheet() {
    double _dragTo = ((_screenSize.height * 0.45) + _drag);
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
      child: _cakeDetails(),
    );
  }

  Column _cakeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.cakeModel.name, style: textStyle(color: Colors.black87)),
        Text('\u{20B9}${widget.cakeModel.price.round().toString()}',
            style: textStyle(color: Colors.black87)),
        SizedBox(height: 20.h),
        Text('Ingredients', style: textStyle(color: Colors.black87)),
        SizedBox(height: 20.h),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 20.w,
          children: [
            _ingredients(),
            _ingredients(),
            _ingredients(),
            _ingredients(),
          ],
        ),
        SizedBox(height: 20.h),
        Text('Details', style: textStyle(color: Colors.black87)),
        SizedBox(height: 20.h),
        Text(widget.cakeModel.details, style: textStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _ingredients({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ??
          () {
            print('Ingredients');
          },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFC2C2C2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 80.h,
          width: 65.w,
        ),
      ),
    );
  }

  Color _cardColor(BuildContext context) {
    switch (widget.cardColor) {
      case CakeCardColor.corn:
        return MyColorScheme.corn;
      case CakeCardColor.englishVermillion:
        return MyColorScheme.englishVermillion;
      case CakeCardColor.terraCotta:
        return MyColorScheme.terraCotta;
      default:
        return MyColorScheme.corn;
    }
  }
}
