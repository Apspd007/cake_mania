import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:cake_mania/Models/OrderStatusEnums.dart';
import 'package:cake_mania/Models/PaymentStatusEnums.dart';

class OrderBillModel  {
  final List<CakeOrderModel> cakeOrderModel;
  final OrderStatus orderStatus;
  final PaymentStatus paymentStatus;
  final double totalPrice;
  final String orderId;

  OrderBillModel({
    required this.cakeOrderModel,
    required this.totalPrice,
    required this.orderId,
    this.orderStatus = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.unpaid,
  });

  static List<OrderBillModel> jsonToOrderBillList(Map<String, dynamic> json) {
    List<OrderBillModel> list = [];
    json.forEach((key, value) {
      list.add(OrderBillModel.fromJson(value));
    });
    return list;
  }

  factory OrderBillModel.fromJson(json) => OrderBillModel(
        cakeOrderModel: CakeOrderModel.jsonToOrderList(json, "cakeOrderModel"),
        totalPrice: json["totalPrice"],
        orderId: json["orderId"],
        paymentStatus: PaymentStatusConvertor.fromJson(json["paymentStatus"]),
        orderStatus: OrderStatusConvertor.fromJson(json["orderStatus"]),
      );
  static Map<String, dynamic> toJson(OrderBillModel orderBillModel) => {
        // static  => {
        "cakeOrderModel": CakeOrderModel.orderListToJson(
            orderBillModel.cakeOrderModel, "cakeOrderModel")["cakeOrderModel"],
        "orderId": orderBillModel.orderId,
        "totalPrice": orderBillModel.totalPrice,
        "paymentStatus":
            PaymentStatusConvertor.toJson(orderBillModel.paymentStatus),
        "orderStatus": OrderStatusConvertor.toJson(orderBillModel.orderStatus),
      };
}
