import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/DeliveryDetailsModel.dart';
import 'package:cake_mania/Notifiers/DeliveryModelNotifier.dart';
import 'package:cake_mania/services/AuthenticationService.dart';
import 'package:cake_mania/services/FirestoreDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditDeliveryDetails extends StatefulWidget {
  final LocalUser user;
  EditDeliveryDetails({required this.user});
  @override
  _EditDeliveryDetailsState createState() => _EditDeliveryDetailsState();
}

class _EditDeliveryDetailsState extends State<EditDeliveryDetails> {
  final formKey = GlobalKey<FormState>();
  String? address;
  String? pinCode;
  String? mobileNumber;
  @override
  void didChangeDependencies() {
    final deliveryNotifier = Provider.of<DeliveryModelNotifier>(context);
    if (deliveryNotifier.deliveryModel != null) {
      address = deliveryNotifier.deliveryModel!.address;
      pinCode = deliveryNotifier.deliveryModel!.pinCode;
      mobileNumber = deliveryNotifier.deliveryModel!.mobileNumber;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    DeliveryModelNotifier deliveryNotifier =
        context.watch<DeliveryModelNotifier>();
    return Scaffold(
      appBar: AppBar(
          title:
              Text("Details", style: lobster2TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        child: Container(
          height: 430.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _textField(
                    initialValue: address,
                    labelText: "Address",
                    maxLines: 2,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Provider an Address';
                      }
                      address = value;
                    }),
                SizedBox(height: 20.h),
                _textField(
                  initialValue: pinCode,
                  labelText: "Pincode",
                  textInputAction: TextInputAction.next,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Provide a Pincode';
                    } else if (value.length != 6) {
                      return 'Pincode is not Valid';
                    }
                    pinCode = value;
                  },
                ),
                SizedBox(height: 20.h),
                _textField(
                  initialValue: mobileNumber,
                  labelText: "Mobile Number",
                  textInputAction: TextInputAction.done,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Provide a Mobile No.';
                    } else if (value.length != 10) {
                      return 'Mobile Number is not Valid';
                    }
                    mobileNumber = value;
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40.h,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                            MyColorScheme.brinkPink,
                          )),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              deliveryNotifier.changeDeliveryDetails(
                                  DeliveryDetailsModel(
                                      address: address!,
                                      mobileNumber: mobileNumber!,
                                      pinCode: pinCode!));
                              final json = DeliveryDetailsModel.toJson(
                                  DeliveryDetailsModel(
                                address: address!,
                                mobileNumber: mobileNumber!,
                                pinCode: pinCode!,
                              ));
                              db.updateUserDeliveryDetails(
                                  widget.user.uid, json);
                            }
                            Navigator.pop(context);
                          },
                          child: Text("Save",
                              style: lobster2TextStyle(color: Colors.white))),
                    ),
                    SizedBox(
                      height: 40.h,
                      child: OutlinedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide?>(
                                BorderSide(
                          color: Colors.black87,
                        ))),
                        child: Text("Cancel",
                            style: lobster2TextStyle()),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _textField({
    required String labelText,
    required String? initialValue,
    String? Function(String?)? validator,
    int? maxLines,
    int? maxLength,
    required TextInputAction textInputAction,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      style: lobster2TextStyle(enableShadow: false, color: Colors.black87),
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      cursorColor: Colors.black87,
      decoration: InputDecoration(
        labelText: labelText,
        errorStyle: lobster2TextStyle(
            fontSize: 16, enableShadow: false, color: Colors.red),
        labelStyle: lobster2TextStyle(
          enableShadow: false,
          color: MyColorScheme.brinkPink,
        ),
        errorBorder: OutlineInputBorder(
            gapPadding: 10,
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3,
            )),
        border: OutlineInputBorder(
            gapPadding: 10,
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3,
            )),
        enabledBorder: OutlineInputBorder(
            gapPadding: 10,
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: MyColorScheme.brinkPink,
              width: 3,
            )),
        focusedBorder: OutlineInputBorder(
            gapPadding: 10,
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: MyColorScheme.brinkPink,
              width: 3,
            )),
      ),
      validator: validator,
    );
  }
}
