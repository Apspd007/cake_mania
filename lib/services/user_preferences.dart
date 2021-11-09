import 'dart:convert';
import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:cake_mania/Models/UserSettingsModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class UserPreference {
  // static late final SharedPreferences _preferences;
  static final _preference = GetStorage('orderDetails');
  static final String _keyCakeOrderDetails = 'cakeOrderDetails';
  static final _userSettings = GetStorage('userSettings');
  static final String _keyUserSettings = 'keyUserSettings';

  static Future init() async {
    await GetStorage.init('orderDetails');
    await GetStorage.init('userSettings');
  }

  static saveOrderDetails(BuildContext context) async {
    final data = Provider.of<CakeOrderNotifier>(context, listen: false);
    final json = jsonEncode(CakeOrderModel.orderListToJson(
        data.cakeOrderModel, _keyCakeOrderDetails));
    _preference.write(_keyCakeOrderDetails, json);
  }

  static saveUserSettings(UserSettingsModel userSettings) async {
    final json = jsonEncode(UserSettingsModel.toJson(userSettings));
    _preference.write(_keyUserSettings, json);
  }

  static UserSettingsModel getUserSettings() {
    final data = _userSettings.read(_keyUserSettings);
    UserSettingsModel userSettings = UserSettingsModel();
    if (data != null) {
      final Map<String, dynamic> json = jsonDecode(data);
      userSettings = UserSettingsModel.fromJson(json);
    }
    return userSettings;
  }

  static List<CakeOrderModel> getOrderDetails() {
    final json = _preference.read(_keyCakeOrderDetails);
    final List<CakeOrderModel> _value = json == null
        ? []
        : CakeOrderModel.jsonToOrderList(
            jsonDecode(json), _keyCakeOrderDetails);
    return _value;
  }

  static clearOrderData() {
    _preference.erase();
  }
}
