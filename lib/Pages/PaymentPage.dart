// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:cake_mania/Materials.dart';
// import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
// import 'package:cake_mania/Notifiers/DeliveryModelNotifier.dart';
// import 'package:cake_mania/services/AuthenticationService.dart';
// import 'package:cake_mania/services/FirestoreDatabase.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:random_string/random_string.dart';

// class PaymentPage extends StatefulWidget {
//   final LocalUser user;
//   final double totalPrice;
//   PaymentPage({
//     required this.user,
//     required this.totalPrice,
//   });
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   late Database database;
//   late CakeOrderNotifier cakeOrderNotifier;
//   late DeliveryModelNotifier deliveryModelNotifier;
//   final orderId = randomString(12);
//   final bool testing = true;
//   final String mid = 'qpMgpe86936439027381';
//   bool loading = false;
//   String paymentResponse = '';

//   @override
//   void didChangeDependencies() {
//     database = Provider.of<Database>(context);
//     cakeOrderNotifier = Provider.of<CakeOrderNotifier>(context);
//     deliveryModelNotifier = Provider.of<DeliveryModelNotifier>(context);

//     super.didChangeDependencies();
//   }

//   // void _afterPayment(
//   //     {required CakeOrderNotifier cakeOrderNotifier,
//   //     required Database database}) {
//   //   final json = OrderBillModel.toJson(OrderBillModel(
//   //     totalPrice: widget.totalPrice,
//   //     orderId: orderId,
//   //     cakeOrderModel: cakeOrderNotifier.cakeOrderModel,
//   //   ));
//   //   database.confirmOrder(
//   //       orderId: orderId,
//   //       order: json,
//   //       user: widget.user,
//   //       deliveryDetails:
//   //           DeliveryDetailsModel.toJson(deliveryModelNotifier.deliveryModel!));
//   //   cakeOrderNotifier.deleteAllOrders();
//   //   UserPreference.clearData();
//   //   setState(() {});
//   //   Future.delayed(Duration(milliseconds: 250)).then((value) {
//   //     Navigator.of(context).popUntil((route) => route.isFirst);
//   //   });
//   // }

//   // void initPayment() {
//   //   var responce = AllInOneSdk.startTransaction(
//   //     mid,
//   //     orderId,
//   //     widget.totalPrice.toString(),
//   // txnToken,
//   //     callbackUrl,
//   //     isStaging,
//   //     restrictAppInvoke,
//   //   );
//   // }

//   void showToast({required String msg}) {
//     Fluttertoast.showToast(
//       msg: msg,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red[400],
//       textColor: Colors.white,
//     );
//   }

//   void generateTxnToken(int mode) async {
//     String callBackUrl = (testing
//             ? 'https://securegw-stage.paytm.in'
//             : 'https://securegw.paytm.in') +
//         '/theia/paytmCallback?ORDER_ID=' +
//         orderId;

//     //Host the Server Side Code on your Server and use your URL here. The following URL may or may not work. Because hosted on free server.
//     //Server Side code url: https://github.com/mrdishant/Paytm-Plugin-Server
//     var url =
//         'http://10.0:5001/cake-mania-aa560/us-central1/paymentFunction';

//     var body = json.encode({
//       "mid": mid,
//       "key_secret": 'QJO@lcOYetnG1ziO',
//       "website": 'WEBSTAGING',
//       "orderId": orderId,
//       "amount": widget.totalPrice.toString(),
//       "callbackUrl": callBackUrl,
//       "custId": "122",
//       "mode": mode.toString(),
//       "testing": testing ? 0 : 1
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: body,
//         headers: {'Content-type': "application/json"},
//       );
//       print("Response is");
//       print(response.body);
//       String txnToken = response.body;
//       setState(() {
//         paymentResponse = txnToken;
//       });

//       var paytmResponse = Paytm.payWithPaytm(mid, orderId, txnToken,
//           widget.totalPrice.toString(), callBackUrl, testing);

//       paytmResponse.then((value) {
//         print(value);
//         setState(() {
//           loading = false;
//           print("Value is ");
//           print(value);
//           if (value['error']) {
//             paymentResponse = value['errorMessage'];
//           } else {
//             if (value['response'] != null) {
//               paymentResponse = value['response']['STATUS'];
//             }
//           }
//           paymentResponse += "\n" + value.toString();
//         });
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightGreen[50],
//       appBar: AppBar(
//         title: Text(
//           'Select a Payment Method',
//           style: poppinsTextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//         child: Column(
//           children: <Widget>[
//             Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: MyColorScheme.brinkPink,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "UPI",
//                       style: poppinsTextStyle(color: Colors.white),
//                     ),
//                     displayUpiApps(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget displayUpiApps() {
//     return Container(
//       height: 100,
//       width: 100,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           TextButton(
//             onPressed: () {
//               generateTxnToken(2);
//             },
//             child: Text('Button'),
//           ),
//         ],
//       ),
//     );
//   }
// }
