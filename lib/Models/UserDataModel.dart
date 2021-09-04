import 'dart:convert';

import 'package:cake_mania/Models/CakeModel.dart';
import 'package:cake_mania/Models/OrderBillModel.dart';

class UserData {
  final List<int> favourites;
  final List<CakeModel> previousOrderss;
  final List<OrderBillModel> confirmOrders;
  UserData({
    required this.favourites,
    required this.previousOrderss,
    required this.confirmOrders,
  });

  static Map<String, dynamic> toJson(UserData userData) => {
        "UserData": {
          "favourites": userData.favourites,
          "previousOrders": userData.favourites,
          "currentOrders": userData.favourites,
        }
      };

  static userDataFromJson(Object? json) =>
      UserData.from(jsonDecode(jsonEncode(json)));

  static List<int> _jsonToList(dynamic json) {
    if (json != null) {
      return List<int>.from(json.map((x) => x));
    } else {
      return [];
    }
  }

  factory UserData.from(Map<String, dynamic> json) => UserData(
        favourites: _jsonToList(json["UserData"]["favourites"]),
        previousOrderss: [],
        confirmOrders: OrderBillModel.jsonToOrderBillList(
            json["UserData"]["confirmOrders"]),
      );
}
