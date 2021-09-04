import 'package:cake_mania/Models/OrderBillModel.dart';
import 'package:flutter/cupertino.dart';

class OrderBillNotifier extends ChangeNotifier {
  List<OrderBillModel> _orderBillModel = [];
  List<OrderBillModel> get orderBillModel => _orderBillModel;
  addOrderBill(List<OrderBillModel> orderBill) {
    _orderBillModel.addAll(orderBill);
  }
}
