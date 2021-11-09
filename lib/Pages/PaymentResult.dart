// import 'package:cake_mania/Materials.dart';
// import 'package:flutter/material.dart';
// import 'package:upi_india/upi_india.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class PaymentResult extends StatelessWidget {
//   final UpiResponse upiResponse;
//   PaymentResult({required this.upiResponse});

//   Widget _paymentResponse(UpiResponse? response) {
//     final _upiResponse = response;
//     String? txnId = _upiResponse!.transactionId;
//     String? resCode = _upiResponse.responseCode;
//     String? txnRef = _upiResponse.transactionRefId;
//     String? status = _upiResponse.status;
//     String? approvalRef = _upiResponse.approvalRefNo;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Transaction Id: $txnId\n',
//           style: poppinsTextStyle(
//             fontSize: 15,
//           ),
//         ),
//         Text(
//           'Response Code: $resCode\n',
//           style: poppinsTextStyle(
//             fontSize: 15,
//           ),
//         ),
//         Text(
//           'Reference Id: $txnRef\n',
//           style: poppinsTextStyle(
//             fontSize: 15,
//           ),
//         ),
//         Text(
//           'Status: $status\n',
//           style: poppinsTextStyle(
//             fontSize: 15,
//           ),
//         ),
//         Text(
//           'Approval No: $approvalRef',
//           style: poppinsTextStyle(
//             fontSize: 15,
//           ),
//         ),
//       ],
//     );
//   }

//   Color _paymentColor() {
//     if (upiResponse.status == UpiPaymentStatus.SUCCESS) {
//       return Colors.green.shade400;
//     } else if (upiResponse.status == UpiPaymentStatus.FAILURE) {
//       return Colors.red.shade400;
//     } else {}
//     return Colors.yellow.shade400;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(upiResponse.transactionRefId);
//     return Scaffold(
//       floatingActionButton: SizedBox(
//         width: 200.w,
//         height: 60.h,
//         child: FloatingActionButton(
//           elevation: 2,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(
//             'Go Back',
//             style: poppinsTextStyle(color: Colors.white),
//           ),
//           backgroundColor: upiResponse.status == UpiPaymentStatus.SUCCESS
//               ? Colors.green[400]
//               : Colors.red[400],
//           focusColor: Colors.transparent,
//           splashColor: Colors.white,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               flex: 4,
//               child: Container(
//                 color: _paymentColor(),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.white,
//                             child: Icon(
//                               Icons.close_rounded,
//                               size: 40.r,
//                               color: Colors.red,
//                             ),
//                           ),
//                           Text(
//                             upiResponse.status!,
//                             style: poppinsTextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 6,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
//                 child: _paymentResponse(upiResponse),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
