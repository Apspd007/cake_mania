import 'package:flutter/foundation.dart';

class CakeDetailsNotifier extends ChangeNotifier {
  String? flavour;
  String? weight;
  String? occasion;
  String? message;
  String? theme;
  
  void fillCakeDetails({
    required String flavour,
    required String weight,
    required String occasion,
    required String message,
    required String theme,
  }) {
    this.flavour = flavour;
    this.weight = weight;
    this.occasion = occasion;
    this.message = message;
    this.theme = theme;
    notifyListeners();
  }

  void changeDetailOf({
    String? flavour,
    String? weight,
    String? occasion,
    String? message,
    String? theme,
  }) {
    this.flavour = flavour ?? this.flavour;
    this.weight = weight ?? this.weight;
    this.occasion = occasion ?? this.occasion;
    this.message = message ?? this.message;
    this.theme = theme ?? this.theme;
    notifyListeners();
  }

  void clearFieldFor({
    bool? flavour,
    bool? weight,
    bool? occasion,
    bool? message,
    bool? theme,
  }) {
    this.flavour = flavour == true ? null : this.flavour;
    this.weight = weight == true ? null : this.weight;
    this.occasion = occasion == true ? null : this.occasion;
    this.message = message == true ? null : this.message;
    this.theme = theme == true ? null : this.theme;
    notifyListeners();
  }

  void clearCakeDetails() {
    this.flavour = null;
    this.weight = null;
    this.occasion = null;
    this.message = null;
    this.theme = null;
    notifyListeners();
  }
}
