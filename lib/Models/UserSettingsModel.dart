import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';

class OrderRelatedSettings extends ChangeNotifier {
  bool notifyPaidOrder;
  String orderId;
  OrderRelatedSettings({
    required this.notifyPaidOrder,
    required this.orderId,
  });
  // static void init() {
  //   UserPreference.saveUserSettings(UserSettingsModel(
  //     notifyPaidOrder: false,
  //   ));
  // }

  void changeUserSettings({
    bool? notifyPaidOrder,
  }) {
    this.notifyPaidOrder = notifyPaidOrder ?? this.notifyPaidOrder;
    notifyListeners();
    UserPreference.saveUserSettings(OrderRelatedSettings(
        notifyPaidOrder: this.notifyPaidOrder, orderId: ''));
  }

  void defaultUserSettings() {
    this.notifyPaidOrder = false;
    notifyListeners();
    UserPreference.saveUserSettings(OrderRelatedSettings(
      notifyPaidOrder: false,
      orderId: '',
    ));
  }

  factory OrderRelatedSettings.fromJson(json) => OrderRelatedSettings(
        notifyPaidOrder: json['notifyPaidOrder'],
        orderId: json['orderId'] ?? '',
      );

  static Map<String, dynamic> toJson(OrderRelatedSettings userSettings) => {
        'notifyPaidOrder': userSettings.notifyPaidOrder,
        'orderId': userSettings.orderId,
      };
}
