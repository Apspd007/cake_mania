import 'package:cake_mania/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';

class UserSettingsModel extends ChangeNotifier {
  bool notifyPaidOrder;
  UserSettingsModel({
    this.notifyPaidOrder = false,
  });
  static void init() {
    UserPreference.saveUserSettings(UserSettingsModel(
      notifyPaidOrder: false,
    ));
  }

  void changeUserSettings({
    bool? notifyPaidOrder,
  }) {
    this.notifyPaidOrder = notifyPaidOrder ?? this.notifyPaidOrder;
    notifyListeners();
    UserPreference.saveUserSettings(UserSettingsModel(
      notifyPaidOrder: this.notifyPaidOrder,
    ));
  }

  void defaultUserSettings() {
    this.notifyPaidOrder = false;
    notifyListeners();
    UserPreference.saveUserSettings(UserSettingsModel(
      notifyPaidOrder: false,
    ));
  }

  factory UserSettingsModel.fromJson(json) => UserSettingsModel(
        notifyPaidOrder: json['notifyPaidOrder'],
      );

  static Map<String, dynamic> toJson(UserSettingsModel userSettings) => {
        'notifyPaidOrder': userSettings.notifyPaidOrder,
      };
}
