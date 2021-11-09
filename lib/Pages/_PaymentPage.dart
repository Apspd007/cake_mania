// import 'package:cake_mania/Materials.dart';
// import 'package:cake_mania/Models/DeliveryDetailsModel.dart';
// import 'package:cake_mania/Models/OrderBillModel.dart';
// import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
// import 'package:cake_mania/Notifiers/DeliveryModelNotifier.dart';
// import 'package:cake_mania/Pages/PaymentResult.dart';
// import 'package:cake_mania/services/AuthenticationService.dart';
// import 'package:cake_mania/services/FirestoreDatabase.dart';
// import 'package:cake_mania/services/user_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:random_string/random_string.dart';
// import 'package:upi_india/upi_india.dart';

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

//   Future<UpiResponse>? _transaction;
//   String orderId = randomNumeric(15);
//   String tranRefId = randomNumeric(12);
//   UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? apps;

//   @override
//   void didChangeDependencies() {
//     database = Provider.of<Database>(context);
//     cakeOrderNotifier = Provider.of<CakeOrderNotifier>(context);
//     deliveryModelNotifier = Provider.of<DeliveryModelNotifier>(context);

//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     _upiIndia.getAllUpiApps(
//       includeOnly: [
//         UpiApp.googlePay,
//         UpiApp.amazonPay,
//         UpiApp.paytm,
//         UpiApp.phonePe,
//       ],
//       mandatoryTransactionId: true,
//     ).then((value) {
//       setState(() {
//         apps = value;
//       });
//     });

//     super.initState();
//   }

//   void _afterPayment(
//       {required CakeOrderNotifier cakeOrderNotifier,
//       required Database database}) {
//     final json = OrderBillModel.toJson(OrderBillModel(
//       totalPrice: widget.totalPrice,
//       orderId: orderId,
//       cakeOrderModel: cakeOrderNotifier.cakeOrderModel,
//     ));
//     database.confirmOrder(
//         orderId: orderId,
//         order: json,
//         user: widget.user,
//         deliveryDetails:
//             DeliveryDetailsModel.toJson(deliveryModelNotifier.deliveryModel!));
//     cakeOrderNotifier.deleteAllOrders();
//     UserPreference.clearData();
//     setState(() {});
//     Future.delayed(Duration(milliseconds: 250)).then((value) {
//       Navigator.of(context).popUntil((route) => route.isFirst);
//     });
//   }

//   Future<UpiResponse> initiateTransaction(UpiApp app) async {
//     return _upiIndia.startTransaction(
//       app: app,
//       merchantId: orderId,
//       receiverUpiId: 'chhotelalkashyap0@oksbi',
//       receiverName: 'Chhote lal Kashyap',
//       transactionRefId: tranRefId,
//       transactionNote: 'Make a payment for Cake',
//       amount: widget.totalPrice,
//     );
//   }

//   Widget displayUpiApps() {
//     if (apps == null)
//       return Center(child: CircularProgressIndicator());
//     else if (apps!.length == 0)
//       return Center(child: Text("No apps found to handle transaction."));
//     else
//       return Wrap(
//         children: apps!.map<Widget>((UpiApp app) {
//           return GestureDetector(
//             onTap: () {
//               _transaction = initiateTransaction(app);
//               setState(() {});
//             },
//             child: Container(
//               height: 100,
//               width: 100,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Image.memory(
//                     app.icon,
//                     height: 60,
//                     width: 60,
//                   ),
//                   Text(
//                     app.name,
//                     style: poppinsTextStyle(color: Colors.white, fontSize: 15),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       );
//   }

//   void showToast({required String msg}) {
//     Fluttertoast.showToast(
//       msg: msg,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red[400],
//       textColor: Colors.white,
//     );
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
//             Container(
//               height: 400,
//               child: FutureBuilder<UpiResponse>(
//                 future: _transaction,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<UpiResponse> snapshot) {
//                   print(snapshot);
//                   if (snapshot.hasError) {
//                     switch (snapshot.error.runtimeType) {
//                       case UpiIndiaAppNotInstalledException:
//                         print("Requested app not installed on device");
//                         showToast(msg: 'Requested app not installed on device');
//                         break;

//                       case UpiIndiaUserCancelledException:
//                         print("User Canceled the payment");
//                         showToast(msg: 'You\'ve Canceled the payment');

//                         break;
//                       case UpiIndiaNullResponseException:
//                         print("Requested app didn't return any response");
//                         showToast(msg: 'No responce from Upi');
//                         break;
//                       case UpiIndiaInvalidParametersException:
//                         print("Requested app cannot handle the transaction");
//                         showToast(msg: 'Upi couldn\'t handle the Payment');
//                         break;
//                       default:
//                         print("An Unknown error has occurred");
//                         showToast(msg: 'Some Unknwown error occurrded');
//                         break;
//                     }
//                     return SizedBox.shrink();
//                     // return AlertDialog(
//                     //     title: Text('Some Error occurred'),
//                     //     actions: [
//                     //       TextButton(
//                     //           onPressed: () {
//                     //             Navigator.pop(context);
//                     //           },
//                     //           child: Text('ok'))
//                     //     ]);
//                   }
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     if (snapshot.data!.status == UpiPaymentStatus.SUCCESS) {
//                       _afterPayment(
//                           cakeOrderNotifier: cakeOrderNotifier,
//                           database: database);
//                     }
//                     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (_) => PaymentResult(
//                                 upiResponse: snapshot.data!,
//                               )));
//                     });
//                     return SizedBox.shrink();
//                   } else
//                     return SizedBox.shrink();
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
