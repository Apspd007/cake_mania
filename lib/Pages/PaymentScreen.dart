// import 'dart:convert';
// import 'package:cake_mania/services/Constants.dart';
// import 'package:flutter/material.dart';
// import 'package:random_string/random_string.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentScreen extends StatefulWidget {
//   final String amount;

//   PaymentScreen({required this.amount});

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   WebViewController? _webController;
//   bool _loadingPayment = true;
//   String _responseStatus = STATUS_LOADING;

//   String _loadHTML() {
//     return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${randomNumeric(12)}'/>" +
//         "<input  type='hidden' name='custID' value='${ORDER_DATA["custID"]}' />" +
//         "<input  type='hidden' name='amount' value='${widget.amount}' />" +
//         "<input type='hidden' name='custEmail' value='${ORDER_DATA["custEmail"]}' />" +
//         "<input type='hidden' name='custPhone' value='${ORDER_DATA["custPhone"]}' />" +
//         "</form> </body> </html>";
//   }

//   void getData(WebViewController controller) {
//     controller.evaluateJavascript("document.body.innerText").then((data) {
//       var decodedJSON = jsonDecode(data);
//       Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
//       final checksumResult = responseJSON["status"];
//       final paytmResponse = responseJSON["data"];
//       if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
//         if (checksumResult == 0) {
//           _responseStatus = STATUS_SUCCESSFUL;
//         } else {
//           _responseStatus = STATUS_CHECKSUM_FAILED;
//         }
//       } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
//         _responseStatus = STATUS_FAILED;
//       }
//       print("type: " + paytmResponse.runtimeType.toString());
//       print("data: $paytmResponse");
//       this.setState(() {});
//     });
//   }

//   Widget getResponseScreen() {
//     switch (_responseStatus) {
//       case STATUS_SUCCESSFUL:
//         return PaymentSuccessfulScreen();
//       case STATUS_CHECKSUM_FAILED:
//         return CheckSumFailedScreen();
//       case STATUS_FAILED:
//         return PaymentFailedScreen();
//     }
//     return PaymentSuccessfulScreen();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _webController!.reload();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Stack(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: WebView(
//               debuggingEnabled: false,
//               javascriptMode: JavascriptMode.unrestricted,
//               onWebViewCreated: (controller) {
//                 _webController = controller;
//                 _webController!.loadUrl(
//                     new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
//                         .toString());
//                 // _webController!.po;
//               },
//               onPageFinished: (page) {
//                 if (page.contains("/process")) {
//                   if (_loadingPayment) {
//                     this.setState(() {
//                       _loadingPayment = false;
//                     });
//                   }
//                 }
//                 if (page.contains("/paymentReceipt")) {
//                   getData(_webController!);
//                 }
//               },
//             ),
//           ),
//           (_loadingPayment)
//               ? Center(
//                   // child: CircularProgressIndicator(),
//                   child: Text('Loading...'),
//                 )
//               : Center(),
//           (_responseStatus != STATUS_LOADING)
//               ? Center(child: getResponseScreen())
//               : Center()
//         ],
//       )),
//     );
//   }
// }

// class PaymentSuccessfulScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Great!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Thank you making the payment!",
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                   color: Colors.black,
//                   child: Text(
//                     "Close",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.popUntil(context, ModalRoute.withName("/"));
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PaymentFailedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "OOPS!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Payment was not successful, Please try again Later!",
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                   color: Colors.black,
//                   child: Text(
//                     "Close",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.popUntil(context, ModalRoute.withName("/"));
//                     // _webController.goBack();
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CheckSumFailedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Oh Snap!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                   color: Colors.black,
//                   child: Text(
//                     "Close",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     // Navigator.popUntil(context, ModalRoute.withName("/"));
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
